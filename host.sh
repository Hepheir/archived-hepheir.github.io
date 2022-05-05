function get_host() {
    echo "$(ifconfig | ggrep "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(?=.+broadcast)" -P -o)"
}

function get_port() {
    echo "4000"
}

echo "================================================================"
echo "Current host is: http://$(ifconfig | ggrep "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(?=.+broadcast)" -P -o):4000"
echo "================================================================"
git submodule update --remote
echo "----------------------------------------------------------------"
bundle exec jekyll serve --draft --incremental --host="0.0.0.0" --port=4000
