"""
Applet: DB Characters
Summary: View Dragon Ball character profiles
Description: View different character profiles from the Dragon Ball universe.
Author: Michael Yagi
"""

load("encoding/base64.star", "base64")
load("encoding/json.star", "json")
load("http.star", "http")
load("random.star", "random")
load("render.star", "render")
load("schema.star", "schema")
load("time.star", "time")

def main(config):
    random.seed(time.now().unix)

    api_endpoint = "https://dragonball-api.com/api/characters"
    debug_output = True

    if debug_output:
        print("------------------------------")
        print("api_endpoint: " + api_endpoint)
        print("debug_output: " + str(debug_output))

    return get_info(api_endpoint, debug_output)

def get_info(api_endpoint, debug_output):
    dbz_characters_json_string = get_data(api_endpoint + "?limit=58", debug_output)

    if dbz_characters_json_string != None and type(dbz_characters_json_string) == "string":
        dbz_characters_dict = json.decode(dbz_characters_json_string, None)

        if dbz_characters_dict != None:
            get_characters_items = dbz_characters_dict["items"]
            get_character_item = get_characters_items[random.number(0, len(get_characters_items) - 1)]
            get_random_character_id = get_character_item["id"]
            character_url = api_endpoint + "/" + str(get_random_character_id) # 39 - test
            get_character_string = get_data(character_url, debug_output)
            if get_character_string != None and type(get_character_string) == "string":
                dbz_character_dict = json.decode(get_character_string, None)

                if dbz_character_dict != None:
                    # print(get_character_item)
                    # print(dbz_character_dict)
                    if debug_output:
                        print("Character ID: " + str(dbz_character_dict["id"]))
                    character_info_dict = get_character_info(dbz_character_dict)
                    if debug_output:
                        print(character_info_dict)

                    image = None
                    if character_info_dict["image"] != None and len(character_info_dict["image"]) > 0:
                        image = get_data(character_info_dict["image"], debug_output)

                    message = "test"
                    row = render.Text(
                        content = message, 
                        font = "tom-thumb", 
                        color = "#FF0000"
                    )

                    return render.Root(
                        child = render.Box(
                            row,
                        ),
                    )

# Build gender, race, affiliation, (name level, ki level, image level)
def get_character_info(info_dict):
    info_keys = info_dict.keys()
    character_info_dict = {
        "name": None,
        "ki": None,
        "image": None,
        "gender": None,
        "race": None,
        "affiliation": None
    }

    states = []
    base_state = {
        "name": None,
        "ki": None,
        "image": None,
    }

    has_transformations = False
    for info_key in info_keys:
        if info_key == "gender" or info_key == "race" or info_key == "affiliation":
            character_info_dict[info_key] = info_dict[info_key]

        if info_key == "name" or info_key == "ki" or info_key == "image":
            base_state[info_key] = info_dict[info_key]

        if info_key == "transformations" and len(info_dict[info_key]) > 0:
            has_transformations = True

    states.append(base_state)
    if has_transformations:
        transformations = info_dict["transformations"]
        for transformation in transformations:
            transformation_keys = transformation.keys()
            transformation_state = {
                "name": None,
                "ki": None,
                "image": None,
            }

            for transformation_key in transformation_keys:
                if transformation_key == "name" or transformation_key == "ki" or transformation_key == "image":
                    transformation_state[transformation_key] = transformation[transformation_key]

            states.append(transformation_state)

    chosen_state = states[random.number(0, len(states) - 1)]
    character_info_dict["name"] = chosen_state["name"]
    character_info_dict["ki"] = chosen_state["ki"]
    character_info_dict["image"] = chosen_state["image"]

    return character_info_dict

def get_data(url, debug_output, headerMap = {}, ttl_seconds = 5):
    if headerMap == {}:
        res = http.get(url, ttl_seconds = ttl_seconds)
    else:
        res = http.get(url, headers = headerMap, ttl_seconds = ttl_seconds)

    headers = res.headers
    isValidContentType = False

    headersStr = str(headers)
    headersStr = headersStr.lower()
    headers = json.decode(headersStr, None)
    contentType = ""
    if headers != None and headers.get("content-type") != None:
        contentType = headers.get("content-type")

        if contentType.find("json") != -1 or contentType.find("image") != -1:
            isValidContentType = True

    if debug_output:
        print("isValidContentType for " + url + " content type " + contentType + ": " + str(isValidContentType))

    if res.status_code != 200 or isValidContentType == False:
        if debug_output:
            print("status: " + str(res.status_code))
            print("Requested url: " + str(url))
    else:
        data = res.body()

        return data

    return None

def get_schema():
    ttl_options = [
        schema.Option(
            display = "5 sec",
            value = "5",
        ),
        schema.Option(
            display = "20 sec",
            value = "20",
        ),
        schema.Option(
            display = "1 min",
            value = "60",
        ),
        schema.Option(
            display = "15 min",
            value = "900",
        ),
        schema.Option(
            display = "1 hour",
            value = "3600",
        ),
        schema.Option(
            display = "24 hours",
            value = "86400",
        ),
    ]

    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "api_url",
                name = "API URL",
                desc = "The API URL. Supports JSON or image types.",
                icon = "globe",
                default = "",
            ),
            schema.Text(
                id = "response_path",
                name = "JSON response path",
                desc = "A comma separated path to the image URL in the response JSON. Use `[rand]` to choose a random index. eg. `json_key_1, 0, [rand], json_key_to_image_url`",
                icon = "code",
                default = "",
                # default = "message",
            ),
            schema.Text(
                id = "request_headers",
                name = "Request headers",
                desc = "Comma separated key:value pairs to build the request headers. eg, `x-api-key:abc123,content-type:application/json`",
                icon = "code",
                default = "",
            ),
            schema.Dropdown(
                id = "ttl_seconds",
                name = "Refresh rate",
                desc = "Refresh data at the specified interval. Useful for when an endpoint serves random images.",
                icon = "clock",
                default = ttl_options[1].value,
                options = ttl_options,
            ),
            schema.Text(
                id = "base_url",
                name = "Base URL",
                desc = "The base URL if needed",
                icon = "globe",
                default = "",
            ),
            schema.Toggle(
                id = "fit_screen",
                name = "Fit screen",
                desc = "Fit image on screen.",
                icon = "arrowsLeftRightToLine",
                default = False,
            ),
            schema.Toggle(
                id = "debug_output",
                name = "Toggle debug messages",
                desc = "Toggle debug messages. Will display the messages on the display if enabled.",
                icon = "bug",
                default = False,
            ),
        ],
    )
