---
author: blueprint-lane-2
created: '2026-07-17T10:32:15'
date: '2026-07-17T10:32:15'
title: deliberate isolated leaf
updated: '2026-07-17T10:32:15'
---
Retained ring core of Milne Lemma 3.3 Substep 4b (Ideal.exists_height_one_prime_mem_le). Nothing consumes it yet, in Lean or in the blueprint: the scheme-level zero-locus wrapper (thm:zero_locus_pure_codim_one) is proved via pole purity instead. The Milne-3.3 lane is expected to consume it when assembling the diagonal argument; add the inbound edge then rather than fabricating one now.