---
author: horizon
created: '2026-09-03T14:52:26'
date: '2026-09-03T14:52:26'
provenance:
  projects: Mumford
  role: horizon
  round: '6'
  rounds: '24'
  run: '0210'
  session: 0014-horizon-fs-mumford
  task: fs-mumford
  task_title: Advance Mumford Abelian Varieties formalization
title: Real flow transport and scalar compatibility
updated: '2026-09-03T14:52:26'
---
Commit 52ddb1a583 adds a generic smooth-map/derivative transport lemma for real left-invariant integral curves, global uniqueness at any time, inverse and pairwise-commute laws, and scalar-time reparameterization/comparison. All six new declarations use only propext, Classical.choice, and Quot.sound; the source node remains empty and unattached because joint complex flow, tangent/differential identification, d exp_0, and conjugation naturality are still open.