---
name: release
description: Use when releasing a helm chart for step-certificates, autocert, or step-issuer. Run as /release <chart-name>.
---

# Helm Chart Release

Releases a helm chart by syncing to the latest upstream version, bumping chart version correctly, opening a PR, and publishing to the helm repository.

## Chart → Upstream Repo Mapping

| Chart directory | Upstream repo | Branch shortname |
|---|---|---|
| `step-certificates` | `smallstep/certificates` | `certificates` |
| `autocert` | `smallstep/autocert` | `autocert` |
| `step-issuer` | `smallstep/step-issuer` | `step-issuer` |

## Steps

### 1. Assess what needs to change

**Check latest upstream release:**

```sh
gh release list --repo <upstream-repo> --exclude-pre-releases --limit 5
```

Pick the latest non-prerelease version. Strip any leading `v` — this becomes the new `appVersion` (e.g., `v0.30.1` → `0.30.1`).

**Check for chart file changes since the last chart release:**

```sh
# Find the commit that last bumped the chart version
LAST=$(git log --oneline -1 -- <chart>/Chart.yaml | cut -d' ' -f1)

# List chart files changed since then, excluding Chart.yaml itself
git diff $LAST HEAD -- '<chart>/' -- ':(exclude)<chart>/Chart.yaml'
```

**Decision:**

- No upstream version change **and** no chart file changes → nothing to release. Inform the user and stop.
- Otherwise, continue.

### 2. Determine version bump type

- Chart files changed (templates, values.yaml, helpers, etc.) → **minor** bump to `version`
- Only `appVersion` is changing, no other chart changes → **patch** bump to `version`

`version` is plain SemVer for the chart itself, independent of `appVersion`.

### 3. Update Chart.yaml

Edit `<chart>/Chart.yaml`:
- `appVersion`: new upstream version (if changed)
- `version`: bumped per the rule above

### 4. Create branch, commit, open PR

```sh
USERNAME=$(git config user.name | tr '[:upper:]' '[:lower:]')
git checkout -b $USERNAME/<branch-shortname>-<new-appVersion>
git add <chart>/Chart.yaml
```

Commit message depends on what changed:
- appVersion updated, no chart file changes: `"Update <chart> to <new-appVersion>"`
- appVersion updated and chart files changed: `"Update <chart> to <new-appVersion> and bump chart version"`
- Chart files only (no appVersion change): `"Bump <chart> chart version to <new-chart-version>"`

```sh
git push -u origin $USERNAME/<branch-shortname>-<new-appVersion>
gh pr create --title "<commit message>" --body ""
```


### 5. Publish to the helm repository

Run `deploy-skill.sh`, which builds the helm package, checks out `gh-pages`, stages the `.tgz` and updated `index.yaml`, and prints the diff:

```sh
./deploy-skill.sh <chart>
```

Capture the diff output and print it **in full** to the user as a fenced `diff` code block in your response — do not truncate, summarize, or use ellipsis. Then use `AskUserQuestion` to ask whether to proceed.

If the user confirms, run (note: `deploy-skill.sh` leaves you on `gh-pages` where `Chart.yaml` doesn't exist, so hardcode the version from the earlier Chart.yaml edit):

```sh
git commit -m "Add <chart>-<version>.tgz"
git push origin gh-pages
git checkout master
```

If the user declines, run `git checkout master` to abort and leave `gh-pages` clean.

Once the publish is complete, output the PR URL from step 4.

## Notes

- `deploy-skill.sh` requires `yq`, `git`, and `helm`
- For `autocert`, also check whether its pinned `step-certificates` dependency version in `Chart.yaml` needs updating
