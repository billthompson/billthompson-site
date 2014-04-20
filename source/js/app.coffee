(($) ->

  orientationHandler = () ->
    o = window.orientation
    $navBar = $('#primary-nav')

    if (o != 90 && o != -90)
      $('body').addClass('has-fixed-nav')
      $navBar.addClass('navbar-fixed-top')
    else
      $('body').removeClass('has-fixed-nav')
      $navBar.removeClass('navbar-fixed-top')


  $(window).on('load', () ->

  )

  $(window).on('orientationchange', () ->
    orientationHandler()
  )
)(jQuery)