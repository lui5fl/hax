const urlSearchParams = new URLSearchParams(window.location.search);
const id = urlSearchParams.get('id');

if (id) {
    window.location.replace(`hax://item/${id}`);
}
