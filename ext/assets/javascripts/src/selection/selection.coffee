class Selection

  $trellosnap     = undefined
  $box            = undefined
  $top_overlay    = undefined
  $right_overlay  = undefined
  $bottom_overlay = undefined
  $left_overlay   = undefined
  win_w           = undefined
  win_y           = undefined
  $cancel         = undefined
  $retake         = undefined
  $capture        = undefined

  @init_selection = ->
    append_selection_box() unless $("#trellosnap").length
    $(document).on "mousedown", (e) ->
      e.preventDefault()
      start_drawing_box mouse_x(e), mouse_y(e)
    .on "mouseup", (e) ->
      e.preventDefault()
      stop_drawing_box()

  reinit_selection = ->
    $trellosnap.remove()
    Selection.init_selection()

  mouse_x = (e) ->
    e.pageX - $trellosnap.offset().left

  mouse_y = (e) ->
    e.pageY - $trellosnap.offset().top

  start_drawing_box = (x, y) ->
    disable_scroll()
    win_w = $(window).outerWidth()
    win_y = $(window).outerHeight()
    $box.css {left: "#{x}px", top: "#{y}px"}
    $top_overlay.css {width: "#{x}px", height: "#{y}px"}
    $right_overlay.css {width: "#{win_w - x}px", height: "#{y}px"}
    $bottom_overlay.css {width: "#{win_w - x}px", height: "#{win_y - y}px"}
    $left_overlay.css {width: "#{x}px", height: "#{win_y - y}px"}

    $(document).on "mousemove", (e)  =>
      resize_selection_box x, y, mouse_x(e), mouse_y(e)
      resize_top_overlay x, mouse_x(e)
      resize_right_overlay x, y, mouse_x(e), mouse_y(e)
      resize_bottom_overlay y, mouse_y(e)

  stop_drawing_box = ->
    $(document).unbind "mousedown"
    $(document).unbind "mouseup"
    $(document).unbind "mousemove"
    append_confirmation_buttons()

  append_selection_box = ->
    $("body").append selection_box_html()
    $trellosnap     = $("#trellosnap")
    $box            = $("#trellosnap-selection-box")
    $top_overlay    = $("#trellosnap-overlay-top")
    $right_overlay  = $("#trellosnap-overlay-right")
    $bottom_overlay = $("#trellosnap-overlay-bottom")
    $left_overlay   = $("#trellosnap-overlay-left")

  selection_box_html = ->
    """
      <div id="trellosnap">
        <div class="trellosnap-overlay" id="trellosnap-overlay-top"></div>
        <div class="trellosnap-overlay" id="trellosnap-overlay-right"></div>
        <div class="trellosnap-overlay" id="trellosnap-overlay-bottom"></div>
        <div class="trellosnap-overlay" id="trellosnap-overlay-left"></div>
        <div id="trellosnap-selection-box"></div>
      </div>
    """

  resize_selection_box = (old_x, old_y, new_x, new_y) ->
    $box.css
      width  : "#{if (new_x >= old_x) then (new_x - old_x) else "0"}px"
      height : "#{if (new_y >= old_y) then (new_y - old_y) else "0"}px"

  resize_top_overlay = (old_x, new_x) ->
    $top_overlay.css "width", "#{if (new_x >= old_x) then new_x else old_x}"

  resize_right_overlay = (old_x, old_y, new_x, new_y) ->
    $right_overlay.css
      width: "#{if (new_x >= old_x) then (win_w - new_x) else (win_w - old_x)}px"
      height: "#{if (new_y >= old_y) then new_y else old_y}px"

  resize_bottom_overlay = (old_y, new_y) ->
    $bottom_overlay.css "height", "#{if (new_y >= old_y) then (win_y - new_y) else (win_y - old_y)}px"

  disable_scroll = ->
    $("html, body").addClass "trellosnap-no-scroll"

  reenable_scroll = ->
    $("html, body").removeClass "trellosnap-no-scroll"

  append_confirmation_buttons = ->
    $box.append confirmation_buttons_html()
    $cancel  = $("#trellosnap-button-cancel")
    $retake  = $("#trellosnap-button-retake")
    $capture = $("#trellosnap-button-capture")
    position_confirmation_buttons()
    bind_confirmation_buttons()

  confirmation_buttons_html = ->
    """
      <div class="trellosnap-button" id="trellosnap-button-cancel"></div>
      <div class="trellosnap-button" id="trellosnap-button-retake"></div>
      <div class="trellosnap-button" id="trellosnap-button-capture"></div>
    """

  position_confirmation_buttons = ->
    if $box.outerHeight() < 65 && $box.outerWidth() < 99
      $box.addClass "small"
    else if $box.outerHeight() < 65
      $box.addClass "short"
    else if $box.outerWidth() < 99
      $box.addClass "narrow"

  bind_confirmation_buttons = ->
    $cancel.on "click", ->
      reenable_scroll()
      $trellosnap.remove()
    $retake.on "click", ->
      reinit_selection()
    $capture.on "click", ->
      image_info = {w: $box.outerWidth(), h: $box.outerHeight(), x: $box.position().left, y: $box.position().top}
      $trellosnap.remove()
      reenable_scroll()
      chrome.runtime.sendMessage {capture: true, image_info: image_info}

jQuery ->
  Selection.init_selection()