Menu = {
    initialize: function() {
        $$('#menu a.menu-item').each(function(menuItem) {
            menuItem.setAttribute('href', 'javascript:void(0);');
            Event.observe(menuItem, 'click', function(event) {
                Menu.clear_menu();
                Element.setStyle(menuItem.up('li').next('li.submenu'), {'display': 'list-item'});
            }.bind(menuItem));
        });
    },
    clear_menu: function() {
        $$('#menu a.menu-item').each(function(menuItem) {
            Element.setStyle(menuItem.up('li').next('li.submenu'), {'display': 'none'});
        });
    }
}