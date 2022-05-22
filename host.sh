function get_host() {
    echo "$(ifconfig | ggrep "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(?=.+broadcast)" -P -o)"
}

function get_port() {
    echo "4000"
}

echo "================================================================"
echo "Current host is: http://$(get_host):$(get_port)"
echo "================================================================"
bundle exec jekyll serve --draft --host="$(get_host)" --port="$(get_port)"