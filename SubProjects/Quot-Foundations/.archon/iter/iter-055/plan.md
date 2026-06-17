# Iter 055 — Plan (Quot-Foundations)

## TL;DR
3 prover lanes, no blueprint-prep round needed (HARD GATE cleared iter-054, content unchanged). progress-critic
dispatched; its 3 correctives all = actions already planned. Coverage debt cleared via additive entries. The
recurring SNAP no-op-filter bug FIXED (keyword now on the filename's physical line).

## progress-critic iter055 (actioned, no rebuttal)
- **GF STUCK** (deadline iter-055): dispatch the close route THIS iter; failure ⟹ NEXT-iter escalation, not
  another round. Done — full route in PROGRESS lane 1.
- **GR CHURNING-borderline** (functor.map_id DROPPED iter-054): proceed with in-code recipe. Done — lane 2.
- **SNAP CHURNING-MECHANICAL** (no-op-filter dropped it iter-051 + iter-054; crux never attempted): fix dispatch
  format. Done — lane 3 keyword on filename line, verified by grep.

## Decision made — close GF this iter (deadline)
GF remaining = (1) `gf_common_basicOpen_basis` Step-3 cross-chart realisation (recipe in-code) + (2) build
`gf_flat_locality_assembly` + `genericFlatness` cover scaffold over `Module.flat_of_isLocalized_span`. Mode
switched fine-grained→`prove` (decomposition is done; recipes exist — fill sorries, don't re-decompose). Weighed:
the assembly is a large `compHom`-instance build that may not fully land in one pass, but the deadline + recipe
maturity make a real close attempt correct over more decomposition. Reversal signal: prover reports the assembly
needs a genuinely missing Mathlib primitive (then escalate/re-spec, per the STUCK contingency).

## Disproof note
genericFlatness re-signed with `[QuasiCompact p]` iter-054 (counterexample: infinite disjoint Spec ℤ, torsion
fibres — documented in-code L3000-3016). Statement now sound; no further disproof pass needed.

## Coverage debt
8 leandag-unmatched → cleared: 5 SNAP `*_tmul`/`piMor_apply` into the consolidated block;
`lem:gr_pullbackFreeIso_id` + `lem:gf_common_basicOpen_basis` new entries; `opensTopology` already `private`.
Also aligned GF spanning-cover prose to the basic-open-equality invariant (iter-054 prover finding).

## Subagent skips
- strategy-critic: STRATEGY.md SHA-unchanged from iter-054; prior verdict (iter-053) SOUND; no live CHALLENGE.
- blueprint-reviewer: iter-054 full review CLEARED the HARD GATE for all 3 active chapters; this iter's chapter
  edits are additive coverage entries + a prose alignment of an already-built declaration — neither changes any
  active to-be-proved declaration. No must-fix-this-iter finding live.
- blueprint-clean: surgical additive edits (math prose, no Lean-tactic leakage); no writer round to clean.
