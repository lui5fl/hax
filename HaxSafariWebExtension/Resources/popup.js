document.addEventListener('DOMContentLoaded', function () {
    setTextContent('title', 'popup_title');
    setTextContent('subtitle', 'popup_subtitle');
});

function setTextContent(elementId, messageName) {
    const message = browser.i18n.getMessage(messageName);
    const element = document.getElementById(elementId);

    element.textContent = message;
}
