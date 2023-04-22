from pprint import pprint
from typing import List, Tuple, Optional
from requests import Session
from bs4 import BeautifulSoup
from json import loads
import re
from tqdm import tqdm

Versions = List[Tuple[Optional[str], str]]

def get_filenames_by_soup(soup: BeautifulSoup) -> List[str]:
    link_tags = soup.select("tr>td:nth-child(2)>a[href*=\"tar\"]:not([href*=\"README\"]):not([href$=\".sig\"]),"
                            "tr>td:nth-child(2)>a[href*=\"zip\"]:not([href*=\"README\"]):not([href$=\".sig\"]),"
                            "tr>td:nth-child(2)>a[href$=\"/\"]:not([href*=\"README\"]):not([href$=\".sig\"])"
                            )
    links = list(map(lambda x: x.attrs["href"], link_tags[1:]))
    return links

def get_versions_with_filename_from_filenames(filenames: List[str]) -> Versions:
    versions = list()
    for fn in filenames:
        match = re.search(rf"-(\d[\d\.]+(\d|a))(\.tar|/)", fn)
        if match:
            v = match.group(1)
        else:
            v = None
        versions.append([v, fn])
    return versions

def get_version_by_versions(versions: Versions, version: str, name: str):
    latest = None
    for v in versions:
        if v[0] != None:
            latest = v[0] if latest == None else latest
            if version == "latest":
                return v[0]
            else:
                if v[0].startswith(version):
                    return v[0]
    if latest:
        print(f"[{name}][warn] {version} not found, use latest ({latest}) instead")
        return latest
    else:
        raise Exception(f"[{name}][error] {version} not found")

def get_filepaths_from_versions(name: str, versions: Versions, matched_version: str):
    filepaths: List[str] = list()
    for v in versions:
        if v[0] == matched_version:
            filepaths.append(v[1])
    if name == "gcc":
        for i, filepath in enumerate(filepaths):
            if filepath.endswith("/"):
                filepaths[i] = filepath + f"{name}-{matched_version}.tar.xz"
    return filepaths

def get_filepath_from_priority(filepaths: List[str], priority: List[str]):
    for pri in priority:
        for fp in filepaths:
            if fp.endswith(pri):
                return fp
    return filepaths[0]

def get_url_by_version(name: str, version: str, s: Session):
    g = s.get(f"https://ftp.gnu.org/pub/gnu/{name}/?C=M;O=D")
    g.raise_for_status()
    text = g.text
    soup = BeautifulSoup(text, "html.parser")
    filenames = get_filenames_by_soup(soup)
    versions = get_versions_with_filename_from_filenames(filenames)
    matched_version = get_version_by_versions(versions, version, name)
    filepaths = get_filepaths_from_versions(name, versions, matched_version)
    filepath = get_filepath_from_priority(filepaths, priority=[".tar.xz", ".tar.gz", ".zip"])
    url = f"https://ftp.gnu.org/pub/gnu/{name}/{filepath}"
    return url

def main():
    with open("versions.json") as fp:
        versions = loads(fp.read())
    s = Session()
    urls = list()
    for p in tqdm(versions):
        if versions[p].startswith("http"):
            url = versions[p]
        else:
            url = get_url_by_version(p, versions[p], s)
        urls.append(url)
    with open("list.txt", "w") as fp:
        fp.write("\n".join(urls))

if __name__ == "__main__":
    main()
