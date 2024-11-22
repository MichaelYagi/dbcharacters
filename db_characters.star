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
DB_BANNER = base64.decode("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")
HEIGHT_CUM = 6  # 8
SHORT_DURATION = 105
LONG_DURATION = 1000
MAX_CHARS = 16
HEADSHOT_WIDTH = 40
CHARACTER_HEIGHT = 32

def main(config):
    random.seed(time.now().unix)

    api_endpoint = "https://michaelyagi.github.io/js/dragonball/characters.json"
    debug_output = config.bool("debug_output", False)
    show_headshot = config.bool("show_headshot", False)
    ttl_seconds = config.get("ttl_seconds", 3600)
    ttl_seconds = int(ttl_seconds)
    line_one_color = config.str("line_one_color", "#FFFFFF")
    if line_one_color == "":
        line_one_color = "#FFFFFF"
    line_two_color = config.str("line_two_color", "#FFFFFF")
    if line_two_color == "":
        line_two_color = "#FFFFFF"
    line_three_color = config.str("line_three_color", "#FFFFFF")
    if line_three_color == "":
        line_three_color = "#FFFFFF"
    line_four_color = config.str("line_four_color", "#FFFFFF")
    if line_four_color == "":
        line_four_color = "#FFFFFF"
    line_five_color = config.str("line_five_color", "#FFFFFF")
    if line_five_color == "":
        line_five_color = "#FFFFFF"

    if debug_output:
        print("------------------------------")
        print("api_endpoint: " + api_endpoint)
        print("debug_output: " + str(debug_output))
        print("show_headshot: " + str(show_headshot))
        print("ttl_seconds: " + str(ttl_seconds))
        print("line_one_color: " + line_one_color)
        print("line_two_color: " + line_two_color)
        print("line_three_color: " + line_three_color)
        print("line_four_color: " + line_four_color)
        print("line_five_color: " + line_five_color)

    return get_info(api_endpoint, debug_output, show_headshot, line_one_color, line_two_color, line_three_color, line_four_color, line_five_color, ttl_seconds)

def get_info(api_endpoint, debug_output, show_headshot, line_one_color, line_two_color, line_three_color, line_four_color, line_five_color, ttl_seconds):
    character_info_dict = {
        "name": None,
        "gender": None,
        "race": None,
        "ki": None,
        "affiliation": None,
    }
    child = render.Image(width = 64, src = DB_BANNER)
    dbz_characters_json_string = get_data(api_endpoint, debug_output, {}, ttl_seconds)

    if dbz_characters_json_string != None and type(dbz_characters_json_string) == "string":
        dbz_characters_dict = json.decode(dbz_characters_json_string, None)

        if dbz_characters_dict != None:
            get_characters_items = dbz_characters_dict["characters"]
            dbz_character_dict = get_characters_items[random.number(0, len(get_characters_items) - 1)]
            get_random_character_id = dbz_character_dict["id"]

            if dbz_character_dict != None:
                if debug_output:
                    print("Character ID: " + str(dbz_character_dict["id"]))
                character_info_dict = get_character_info(dbz_character_dict, dbz_characters_dict["planets"], debug_output)
                if debug_output:
                    print(character_info_dict)

                # Place on right side
                character_image = None
                if character_info_dict["image_url"] != None and len(character_info_dict["image_url"]) > 0:
                    character_image = get_data(character_info_dict["image_url"], debug_output, {}, ttl_seconds)

                # To be used as BG image
                planet_image = DB_BANNER
                if character_info_dict["planet_image_url"] != None and len(character_info_dict["planet_image_url"]) > 0:
                    planet_image = get_data(character_info_dict["planet_image_url"], debug_output, {}, ttl_seconds)

                # Name
                # Race - Gender
                # Base Ki
                # Affiliation
                child = render_character_profile(character_info_dict, character_image, planet_image, show_headshot, line_one_color, line_two_color, line_three_color, line_four_color, line_five_color)
            elif debug_output:
                character_info_dict["error"] = "JSON response malformed for character at id " + str(get_random_character_id)
                child = render_character_profile(character_info_dict, None, DB_BANNER)
        elif debug_output:
            character_info_dict["error"] = "JSON response malformed for DB endpoint at " + api_endpoint + "?limit=58"
            child = render_character_profile(character_info_dict, None, DB_BANNER)
    elif debug_output:
        character_info_dict["error"] = "Not a valid JSON string for DB endpoint at " + api_endpoint + "?limit=58"
        child = render_character_profile(character_info_dict, None, DB_BANNER)

    return render.Root(
        child,
    )

# character_info_dict - name, ki, image_url, gender, race, affiliation, planet_image_url
def render_character_profile(character_info_dict, character_image, planet_image, show_headshot = False, line_one_color = "#FFFFFF", line_two_color = "#FFFFFF", line_three_color = "#FFFFFF", line_four_color = "#FFFFFF", line_five_color = "#FFFFFF"):
    # Show error
    if character_info_dict["error"] != None and len(character_info_dict["error"]) > 0:
        return render.Column(
            children = [
                render.Box(
                    width = 64,
                    height = 32,
                    child = render.Stack(
                        children = [
                            render.Image(width = 64, src = planet_image),
                            render.Box(
                                color = "#00000080",
                                child = render.WrappedText(content = character_info_dict["error"], font = "tom-thumb", color = "#FFFFFF"),
                            ),
                        ],
                    ),
                ),
            ],
        )

    content_array = []

    if planet_image != None:
        content_array.append(
            render.Image(width = 64, src = planet_image),
        )

    if character_image != None:
        if show_headshot:
            character_render_image = render.Image(
                width = HEADSHOT_WIDTH,
                src = character_image,
            )
        else:
            character_render_image = render.Image(
                height = CHARACTER_HEIGHT,
                src = character_image,
            )

        content_array.append(
            render.Box(
                render.Column(
                    expanded = True,
                    main_align = "space_evenly",
                    cross_align = "center",
                    children = [character_render_image],
                ),
            ),
        )

    content_array.append(
        render.Row(
            children = [render.Padding(
                pad = (56, 1, 0, 0),
                child = render.Image(
                    height = 7,
                    src = DB_ICON,
                ),
            )],
        ),
    )

    # Get character information
    delay = 0
    height = 1

    # Display name
    if character_info_dict["name"] != None and len(character_info_dict["name"]) > 0:
        duration = SHORT_DURATION
        if len(character_info_dict["name"]) > MAX_CHARS:
            duration = LONG_DURATION

        content_array.append(
            render.Box(
                color = "#00000080",
                child = render.Padding(
                    pad = (1, 0, 0, 0),
                    child = animation.Transformation(
                        wait_for_child = True,
                        child = render.Text(character_info_dict["name"], font = "tom-thumb", color = line_one_color),
                        duration = duration,
                        delay = delay,
                        keyframes = getKeyframes(-64 * 2, 0, height, height, height),
                    ),
                ),
            ),
        )

    # Display gender and race
    if (character_info_dict["gender"] != None and len(character_info_dict["gender"]) > 0) or (character_info_dict["race"] != None and len(character_info_dict["race"]) > 0):
        height = height + HEIGHT_CUM

        character_text = ""
        if character_info_dict["gender"] != None and len(character_info_dict["gender"]) > 0:
            character_text = character_text + character_info_dict["gender"]

        if character_info_dict["race"] != None and len(character_info_dict["race"]) > 0:
            character_text = character_text + " " + character_info_dict["race"]

        # if character_info_dict["planet_name"] != None and len(character_info_dict["planet_name"]) > 0:
        #     character_text = character_text + " from " + character_info_dict["planet_name"]

        character_text = character_text.strip()

        duration = SHORT_DURATION
        if len(character_text) > MAX_CHARS:
            duration = LONG_DURATION

        content_array.append(
            render.Padding(
                pad = (1, 0, 0, 0),
                child = animation.Transformation(
                    wait_for_child = True,
                    child = render.Text(character_text, font = "tom-thumb", color = line_two_color),
                    duration = duration,
                    delay = 0,
                    keyframes = getKeyframes(-64 * 2, 0, height, height, height),
                ),
            ),
        )

    # Display planet name
    if character_info_dict["planet_name"] != None and len(character_info_dict["planet_name"]) > 0:
        height = height + HEIGHT_CUM

        duration = SHORT_DURATION
        if len(character_info_dict["planet_name"]) > MAX_CHARS:
            duration = LONG_DURATION

        content_array.append(
            render.Padding(
                pad = (1, 0, 0, 0),
                child = animation.Transformation(
                    wait_for_child = True,
                    child = render.Text(character_info_dict["planet_name"], font = "tom-thumb", color = line_three_color),
                    duration = duration,
                    delay = delay,
                    keyframes = getKeyframes(-64 * 2, 0, height, height, height),
                ),
            ),
        )

    # Display affiliation
    if character_info_dict["affiliation"] != None and len(character_info_dict["affiliation"]) > 0 and character_info_dict["affiliation"] != "Other":
        height = height + HEIGHT_CUM
        duration = SHORT_DURATION
        if len(character_info_dict["affiliation"]) > MAX_CHARS:
            duration = LONG_DURATION

        content_array.append(
            render.Padding(
                pad = (1, 0, 0, 0),
                child = animation.Transformation(
                    wait_for_child = True,
                    child = render.Text(character_info_dict["affiliation"], font = "tom-thumb", color = line_four_color),
                    duration = duration,
                    delay = 0,
                    keyframes = getKeyframes(-64 * 2, 0, height, height, height),
                ),
            ),
        )

    # Display ki
    if character_info_dict["ki"] != None and len(character_info_dict["ki"]) > 0 and character_info_dict["ki"] != "unknown":
        height = height + HEIGHT_CUM

        duration = SHORT_DURATION
        if len(character_info_dict["ki"] + " ki") > MAX_CHARS:
            duration = LONG_DURATION

        content_array.append(
            render.Padding(
                pad = (1, 0, 0, 0),
                child = animation.Transformation(
                    wait_for_child = True,
                    child = render.Text(character_info_dict["ki"] + " ki", font = "tom-thumb", color = line_five_color),
                    duration = duration,
                    delay = 0,
                    keyframes = getKeyframes(-64 * 2, 0, height, height, height),
                ),
            ),
        )

    # Display character and planet clear image
    if character_image != None:
        bg_renders = []
        height = height + HEIGHT_CUM

        if planet_image != None:
            bg_renders.append(render.Image(width = 64, src = planet_image))

        if show_headshot:
            character_render_image = render.Image(
                width = HEADSHOT_WIDTH,
                src = character_image,
            )
        else:
            character_render_image = render.Image(
                height = CHARACTER_HEIGHT,
                src = character_image,
            )

        bg_renders.append(
            render.Box(
                render.Column(
                    expanded = True,
                    main_align = "space_evenly",
                    cross_align = "center",
                    children = [
                        character_render_image,
                    ],
                ),
            ),
        )

        bg_renders.append(
            render.Row(
                children = [render.Padding(
                    pad = (56, 1, 0, 0),
                    child = render.Image(
                        height = 7,
                        src = DB_ICON,
                    ),
                )],
            ),
        )

        content_array.append(
            animation.Transformation(
                wait_for_child = True,
                duration = SHORT_DURATION,
                delay = 100,
                keyframes = getKeyframes(0, 0, 0, 64, 0),
                child = render.Stack(
                    children = bg_renders,
                ),
            ),
        )

        # content_array.append(
        #     animation.Transformation(
        #         wait_for_child = True,
        #         child = render.Stack(
        #             children = [render.Box(
        #                 color = "#00000080"
        #             )]
        #         ),
        #         duration = SHORT_DURATION,
        #         delay = 280,
        #         keyframes = getKeyframes(0, 0, 0, -64, 0),
        #     )
        # )

    return render.Column(
        children = [
            render.Box(
                width = 64,
                height = 32,
                child = render.Stack(
                    children = content_array,
                ),
            ),
        ],
    )

# Build gender, race, affiliation, planet, (name level, ki level, image level)
def get_character_info(characters_dict, planets_dict, debug_output):
    info_keys = characters_dict.keys()
    states = []
    base_state = {
        "name": None,
        "ki": None,
        "planet_name": None,
        "image_url": None,
        "planet_image_url": None,
    }
    character_info_dict = {
        "name": None,
        "ki": None,
        "planet_name": None,
        "image_url": None,
        "planet_image_url": None,
        "gender": None,
        "race": None,
        "affiliation": None,
        "error": None,
    }

    planet_url = ""
    planet_name = ""
    has_transformations = False
    for info_key in info_keys:
        if info_key == "gender" or info_key == "race" or info_key == "affiliation":
            character_info_dict[info_key] = characters_dict[info_key].capitalize()

        if info_key == "name" or info_key == "ki":
            base_state[info_key] = characters_dict[info_key]

        if info_key == "image":
            base_state["image_url"] = characters_dict[info_key]

        if info_key == "transformations" and len(characters_dict[info_key]) > 0:
            has_transformations = True

        if info_key == "planetKey" and len(characters_dict[info_key]) > 0:
            planet_key = characters_dict[info_key]
            planet_info = planets_dict[planet_key]
            planet_url = planet_info["image"]
            planet_name = planet_info["name"]
            base_state["planet_image_url"] = planet_url
            base_state["planet_name"] = planet_name

    states.append(base_state)

    if has_transformations:
        transformations = characters_dict["transformations"]
        for transformation in transformations:
            transformation_keys = transformation.keys()
            transformation_state = {
                "name": None,
                "ki": None,
                "planet_name": planet_name,
                "image_url": None,
                "planet_image_url": planet_url,
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
        chosen_state_keys = chosen_state.keys()
        for chosen_state_key in chosen_state_keys:
            if chosen_state_key == "name" or chosen_state_key == "ki" or chosen_state_key == "image_url" or chosen_state_key == "planet_image_url" or chosen_state_key == "planet_name":
                character_info_dict[chosen_state_key] = chosen_state[chosen_state_key]

    character_info_dict["error"] = None

    return character_info_dict

def getKeyframes(xIn, xOut, yPos = 0, yIn = 0, yOut = 0):
    return [
        animation.Keyframe(
            percentage = 0.0,
            transforms = [animation.Translate(xIn, yIn)],
            curve = "ease_in_out",
        ),
        animation.Keyframe(
            percentage = 0.10,
            transforms = [animation.Translate(0, yPos)],
            curve = "ease_in_out",
        ),
        animation.Keyframe(
            percentage = 0.90,
            transforms = [animation.Translate(0, yPos)],
            curve = "ease_in_out",
        ),
        animation.Keyframe(
            percentage = 1.0,
            transforms = [animation.Translate(xOut, yOut)],
        ),
    ]

def get_data(url, debug_output, headerMap = {}, ttl_seconds = 3600):
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
            display = "5 min",
            value = "300",
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
            schema.Toggle(
                id = "debug_output",
                name = "Toggle debug messages",
                desc = "Toggle debug messages. Will display the messages on the display if enabled.",
                icon = "bug",
                default = False,
            ),
            schema.Toggle(
                id = "show_headshot",
                name = "Show headshot",
                desc = "Toggle headshot for characters. May not always capture headshot for all characters.",
                icon = "userLarge",
                default = False,
            ),
            schema.Text(
                id = "line_one_color",
                name = "Name label color",
                desc = "Name label font color using Hex color codes. eg, `#FFFFFF`.",
                icon = "paintbrush",
                default = "#FFFFFF",
            ),
            schema.Text(
                id = "line_two_color",
                name = "Species/gender label color",
                desc = "Species/gender label font color using Hex color codes. eg, `#FFFFFF`.",
                icon = "paintbrush",
                default = "#FFFFFF",
            ),
            schema.Text(
                id = "line_three_color",
                name = "Origin label color",
                desc = "Origin label font color using Hex color codes. eg, `#FFFFFF`.",
                icon = "paintbrush",
                default = "#FFFFFF",
            ),
            schema.Text(
                id = "line_four_color",
                name = "Affiliation label color",
                desc = "Affiliation label font color using Hex color codes. eg, `#FFFFFF`.",
                icon = "paintbrush",
                default = "#FFFFFF",
            ),
            schema.Text(
                id = "line_five_color",
                name = "Ki amount label color",
                desc = "Ki amount label font color using Hex color codes. eg, `#FFFFFF`.",
                icon = "paintbrush",
                default = "#FFFFFF",
            ),
            schema.Dropdown(
                id = "ttl_seconds",
                name = "Refresh rate",
                desc = "Refresh data at the specified interval.",
                icon = "clock",
                default = ttl_options[2].value,
                options = ttl_options,
            ),
        ],
    )
