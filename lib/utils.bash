#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/addrummond/claney"
TOOL_NAME="claney"
TOOL_TEST="claney -version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if claney is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if claney has other means of determining installable versions.
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	# TODO: Adapt the release URL convention for claney
	local release_arch="$(release_arch_version)}
	url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${release_arch_version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert claney executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

release_arch_version() {
  OS="$(uname -s)"           # e.g. Darwin / Linux
  ARCHITECTURE="$(uname -m)" # e.g. x86_64 / arm64

  if [[ $OS == "Darwin" ]] && [[ $ARCHITECTURE == "arm64" ]]; then
    echo "darwin_arm64"

  elif [[ $OS == "Darwin" ]] && [[ $ARCHITECTURE == "x86_64" ]]; then
    echo "darwin_amd64"

  elif [[ $OS == "Linux" ]] && [[ $ARCHITECTURE == "x86_64" ]]; then
    echo "linux_amd64"

  else
    fail "Unsupported OS... OS: $OS, Arch: $ARCHITECTURE"
  fi
}
