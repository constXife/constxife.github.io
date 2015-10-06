$(document).ready(function() {
    $('pre').each(function(i, block) {
        hljs.highlightBlock(block);
    });

    VK.init({apiId: 3771415, onlyWidgets: true});
    VK.Widgets.Comments('vk_comments', {width: 940, limit: 20, autoPublish: 0, attach: '*'});
});
