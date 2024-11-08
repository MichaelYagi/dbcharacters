"""
Applet: DB Characters
Summary: View Dragon Ball character profiles
Description: View different character profiles from the Dragon Ball universe.
Author: Michael Yagi
"""

load("animation.star", "animation")
load("encoding/base64.star", "base64")
load("encoding/json.star", "json")
load("http.star", "http")
load("random.star", "random")
load("render.star", "render")
load("schema.star", "schema")
load("time.star", "time")

DB_ICON = base64.decode("iVBORw0KGgoAAAANSUhEUgAAABcAAAAXCAYAAADgKtSgAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAALiIAAC4iAari3ZIAAASaSURBVEhLlVXbb1RFGP/NnLN7dktLS1ehlKViDHTlUgghJo3axDcUwcTokw/GSKoG1MQLPKg1NDEY0TdjIg/+A74IBgmEaCKWNSDUIq2QNgZ6WUq3t93t7tnZcxm/7+zSblvS6C97ds58883vu84cgZWwpzPRuaO4N7FGtcciqsWAE83bnn131hvuTenkqXM4C1y4VdFehgeT73t7+5c77K4nNtgHNjUWrIaIgmUoaM9BUXmYy3uYmPUxOC7UxSF5+utT8hjQ01/ZPY9l5G8dfvfQi62FE7vjc9F6IoXvBKTQDnwalXJRoscpOSiVXExlNS4MmPaR380PMPTHNxWaAEZlDPDRkfc/e3VX4fielkLIMj0i86G1Tys+eUHvvg+PZC49jqvh0mMKFxvqVSjmuftSYoM5M3nvlzJbFfl7Hx49/EqbffzxpiJ8ImFSUUVcTc4PG+aRjbBeLOogm/U6ipHm9NTkxBXmlPy3++An25/f4n7R2uTA8wVIncX/Gb4WaFwF7GpWaK1XJ7B+6zaWB+Sdm71P25qdqNY8Y8y/LMYKNiWtbWwA1teqmidjTlcg2/lGd6Ktydtfa3EqAj3C//OcwXsbosBqS6NplfsC6re0ypebvWfjDR6JqvFgz6f/1vBKlckS8I6wCdSEgTrLtRIxb6+Mr9btdYu8Zix4LqjkMgSojEb6Ox/5MQ2D5iJIaBUo75yaMOlbhkYs4rfLeku3mCTQi9nLIFFhyMd0Dx2aM+RAHpg8r3HvksbMLQ3fJSNLMshTKTWipt8iiTgiBPXHvDtVRsiooFBzp30Uk6TTCLi3gZmTREznS9LaPIjVp610gIMI6IlK10NRk1RatRDhaCWCigFq85pHJda8Rla45Yu0kqPCvS4Q20kM9LsfMDewQ5EUqCbsPVHaMqPEsOOxlke5pXIHxLxcBm/ms6RHAfMxktM73QiVxcpI4PRkyHiRDHDf264clqNZkcwp8syxg9SIgLhqF5OTN+s+l9h0UCL+MRUuQgREUg12YnS27JRyBaaKMim/TxlnxzJ05fEF5RIL574K7HXdVomGbTJYqo0LPLxnITIG53imIHBnlqKjsmWUqW5OyXOy79uum9fHjR/nlIRWWVJdvJHBIQfXTCVFrHK/S3h0KcF/pegM0FqJUpyaM88gM3gz6NaTg8ax66mwDZ88D+JdbmApOHFMzJr9RDwyqxGi7I7PWerSlNnNOjQF7l77dSKW6MjEV/nPra0jA1RcrtxKtyJdnSg5Pq7dcdA74iFEvT2RD6MvHT6Svj3wA/MG5IzkpZ7Lsc1Ph9ZFvY61tQ7daOU8iPuGeE5V47Zl8nTWxcVbCgOpMnE6b+H6ZOSrvv4bgdeMeXLGxZ7kz8bGpyZDWj9jCRUKGWRElL33fQ8FOiFj0yVc/aeI34h4MkcfFG1iNFtTIuKjV/v+pM/dAh6c3P3vbD/UlOt6pCZz4CErZ0UMm746CrmCg9k5D4r6vOQamLFDpdGs8dPlKdGdvpHsreyex4qV2/3Sm4lNRn5vrSi0R6BapHainuvb+ZIenraR7M/i/MjlCwMV9SUA/gWgYlO8qLBe2AAAAABJRU5ErkJggg==")

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
            character_url = api_endpoint + "/34" + str(get_random_character_id) # 34 - test
            get_character_string = get_data(character_url, debug_output)
            if get_character_string != None and type(get_character_string) == "string":
                dbz_character_dict = json.decode(get_character_string, None)

                if dbz_character_dict != None:
                    # print(get_character_item)
                    # print(dbz_character_dict)
                    if debug_output:
                        print("Character ID: " + str(dbz_character_dict["id"]))
                    character_info_dict = get_character_info(dbz_character_dict, debug_output)
                    if debug_output:
                        print(character_info_dict)

                    # Place on right side
                    character_image = None
                    if character_info_dict["image_url"] != None and len(character_info_dict["image_url"]) > 0:
                        character_image = get_data(character_info_dict["image_url"], debug_output)

                    # To be used as BG image
                    planet_image = None
                    if character_info_dict["planet_image_url"] != None and len(character_info_dict["planet_image_url"]) > 0:
                        planet_image = get_data(character_info_dict["planet_image_url"], debug_output)

                    # Name
                    # Race - Gender
                    # Base Ki
                    # Affiliation
                    child = render_character_profile(character_info_dict, character_image, planet_image, debug_output)
                    return render.Root(
                        child
                    )

                    # message = "test"
                    # row = render.Text(
                    #     content = message, 
                    #     font = "tom-thumb", 
                    #     color = "#FF0000"
                    # )

                    # return render.Root(
                    #     child = render.Box(
                    #         row,
                    #     ),
                    # )

# character_info_dict - name, ki, image_url, gender, race, affiliation, planet_image_url
def render_character_profile(character_info_dict, character_image, planet_image, debug_output):

    # Get character information
    text_array = []
    if character_info_dict["name"] != None and len(character_info_dict["name"]) > 0:
        text_array.append(render.Text(content = character_info_dict["name"], font = "tom-thumb", color = "#FDA766"))

    if (character_info_dict["gender"] != None and len(character_info_dict["gender"]) > 0) or (character_info_dict["race"] != None and len(character_info_dict["race"]) > 0):
        character_text = ""
        if character_info_dict["gender"] != None and len(character_info_dict["gender"]) > 0:
            character_text = character_text + character_info_dict["gender"]

        if character_info_dict["race"] != None and len(character_info_dict["race"]) > 0:
            character_text = character_text + " " + character_info_dict["race"]

        character_text = character_text.strip()
        text_array.append(render.Text(content = character_text, font = "tom-thumb", color = "#FD9346"))
    
    if character_info_dict["ki"] != None and len(character_info_dict["ki"]) > 0:
        text_array.append(render.Text(content = character_info_dict["ki"], font = "tom-thumb", color = "#FD7F2C"))


    if character_info_dict["affiliation"] != None and len(character_info_dict["affiliation"]) > 0:
        text_array.append(render.Text(content = character_info_dict["affiliation"], font = "tom-thumb", color = "#FF6200"))
    
    # Stack
    stack_array = []

    if planet_image != None:
        stack_array.append(render.Image(width = 64, src = planet_image))

    stack_array.append(render.Image(width = 7, src = DB_ICON))
    stack_array.append(render.Padding(
        pad = (42, 0, 0, 0),
        child = render.Column(
            expanded = True,
            main_align = "space_evenly",
            cross_align = "center",
            children = [render.Image(width = 22, src = character_image)]
        )
    ))
    stack_array.append(
        render.Padding(
            pad = (0, 7, 0, 0),
            child = render.Box(
                color = "#00000080",
                child = render.Padding(
                    pad = (1, 0, 0, 0), 
                    child = render.Column(
                        children = text_array,
                    )
                )
            )
        )
    )
    
    # Render everything
    return render.Column(
        children = [
            render.Column(
                children = [
                    render.Stack(
                        children = stack_array
                    )
                ]
            ),
            
        ]
    )

# Build gender, race, affiliation, planet, (name level, ki level, image level)
def get_character_info(info_dict, debug_output):
    info_keys = info_dict.keys()
    states = []
    base_state = {
        "name": None,
        "ki": None,
        "image_url": None,
        "planet_image_url": None
    }
    character_info_dict = {
        "name": None,
        "ki": None,
        "image_url": None,
        "planet_image_url": None,
        "gender": None,
        "race": None,
        "affiliation": None
    }

    planet_id = 0
    has_transformations = False
    for info_key in info_keys:
        if info_key == "gender" or info_key == "race" or info_key == "affiliation":
            character_info_dict[info_key] = info_dict[info_key]

        if info_key == "name" or info_key == "ki":
            base_state[info_key] = info_dict[info_key]

        if info_key == "image":
            base_state["image_url"] = info_dict[info_key]

        if info_key == "transformations" and len(info_dict[info_key]) > 0:
            has_transformations = True

        if info_key == "originPlanet":
            planet_id = info_dict[info_key]["id"]

    # Lookup planet image
    planet_url = None
    if planet_id > 0:
        planet_lookup = "https://dragonball-api.com/api/planets/" + str(planet_id)
        planet_data = get_data(planet_lookup, debug_output)
        planet_dict = json.decode(planet_data, None)
        if planet_dict != None:
            planet_keys = planet_dict.keys()
            for planet_key in planet_keys:
                if planet_key == "image" and len(planet_dict["image"]) > 0:
                    base_state["planet_image_url"] = planet_dict["image"]
                    planet_url = planet_dict["image"]
                    break

    states.append(base_state)

    if has_transformations:
        transformations = info_dict["transformations"]
        for transformation in transformations:
            transformation_keys = transformation.keys()
            transformation_state = {
                "name": None,
                "ki": None,
                "image_url": None,
                "planet_image_url": planet_url
            }

            for transformation_key in transformation_keys:
                if transformation_key == "name" or transformation_key == "ki":
                    transformation_state[transformation_key] = transformation[transformation_key]

                if transformation_key == "image":
                    transformation_state["image_url"] = transformation[transformation_key]

            states.append(transformation_state)

    if debug_output:
        print(states)

    if len(states) > 0:
        chosen_state = states[random.number(0, len(states) - 1)]
        chosen_state_keys =  chosen_state.keys()
        for key in chosen_state:
            if key == "name" or key == "ki" or key == "image_url" or key == "planet_image_url":
                character_info_dict[key] = chosen_state[key]

    return character_info_dict

def getKeyframes(yIn, xOut):
    return [
        animation.Keyframe(
            percentage = 0.0,
            transforms = [animation.Translate(0, yIn)],
            curve = "ease_in_out",
        ),
        animation.Keyframe(
            percentage = 0.10,
            transforms = [animation.Translate(0, 0)],
            curve = "ease_in_out",
        ),
        animation.Keyframe(
            percentage = 0.90,
            transforms = [animation.Translate(0, 0)],
            curve = "ease_in_out",
        ),
        animation.Keyframe(
            percentage = 1.0,
            transforms = [animation.Translate(xOut, 0)],
        ),
    ]

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
