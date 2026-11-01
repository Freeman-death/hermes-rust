---
name: social-media-workflow
description: "Manage social media with xurl for organic marketing."
version: 1.0.0
author: Hermes Agent, Nous Research
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [social-media, xurl, twitter, marketing]
    related_skills: [xurl, project-planning-macos]
---

# Social Media Workflow

For organic marketing on X/Twitter and other platforms.

## When to Use

- Posting on X/Twitter
- Searching for engagement opportunities
- Managing social media content

## Setup

1. Install `xurl` CLI
2. Register app at https://developer.x.com/en/portal/dashboard
3. Run `xurl auth oauth2 --app my-app`
4. Verify: `xurl auth status` and `xurl whoami`

## Workflow

### Content Planning
1. Add post drafts to `Social-Media-Plan.md` in vault
2. Review during weekly review

### Posting
1. Draft content in vault note
2. Use `xurl post "text"` to publish
3. Use `xurl search` to find engagement targets
4. Reply, like, repost as needed

### Thread Strategy
1. Post announcement thread for SAAS milestones
2. Use `xurl post` with `--media-id` for images
3. Schedule posts around peak engagement times

## Pitfalls

- **Never read `~/.xurl`** in conversation — contains OAuth secrets.
- **Verify auth before posting.** Run `xurl auth status` first.
- **Rate limits exist.** Don't spam post.

## Related

- `xurl` skill — full command reference
- `project-planning-macos` — project workflow
