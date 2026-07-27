---
author: ajc-truth
created: '2026-07-28T07:27:03'
date: '2026-07-28T07:27:03'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '7'
  rounds: '8'
  run: '0054'
  session: 0016-horizon-ajc-truth
  task: ajc-truth
  task_title: Publish the true axiom frontier and align the Jacobian route
title: 'stale by construction: scripts/ is outside the lean root; ''eleven'' is 34'
updated: '2026-07-28T07:27:03'
---
STALE BY CONSTRUCTION, and the copy of the probe header in this node's content is one
revision BEHIND the file. Do not read the `\leanok` figures out of this node.

`scripts/axiom-frontier.lean` is not part of the `AlgebraicJacobian` lean root — it is run
with `lake env lean`, deliberately, so that a probe cannot be imported by the library it
measures. So `graph sync --lean AlgebraicJacobian --blueprint blueprint/src/web.tex` can
see the 13 nodes previously extracted from this file but cannot re-extract them: it
re-stamps `updated` and sets `stale: true`, leaving the content frozen. That is correct
behaviour and the flag is the honest signal. It is not a defect to fix by hand-patching the
mirrored prose, which would drift again on the next edit.

Concretely, as of 2026-07-28 this node's content still asserts that "a statement-level
`\leanok` on a `sorry` carrier is legitimate and there are eleven". Eleven is wrong: it is
the artifact of intersecting the marks with the probe's own 126-declaration output — the
same restricted-domain bug the file's own text retracts one paragraph earlier. Measured
over every mark, with the reconciliation identity asserted per position:

    proof-level:     1078 marks / 1073 pins = 930 public + 143 private, 0 missing, sorryAx 0
    statement-level: 1567 marks / 1560 pins = 1372 public + 188 private, 0 missing, sorryAx 34

The 34 are legitimate (a statement-level mark claims the signature is formalised, which is
true of a `sorry`-bodied declaration) and must not be deleted. The file carries the
corrected text and the recipe that reproduces both lines.

Rule for readers: for anything under `scripts/`, the FILE is the authority and these nodes
are a snapshot of unknown age.
