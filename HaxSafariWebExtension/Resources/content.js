const urlSearchParams = new URLSearchParams(window.location.search);
const id = urlSearchParams.get('id');

if (id) {
    const pathComponents = window.location.pathname.split('/');
    const lastPathComponent = pathComponents[pathComponents.length - 1];

    if (lastPathComponent === 'item') {
        window.location.replace(`hax://item/${id}`);
    } else if (lastPathComponent === 'user') {
        window.location.replace(`hax://user/${id}`);
    }
}
