# mathlib-analogist directive — FBC affine i=0 base-change iso: continue conjugate re-encoding, or pivot?

## Mode: cross-domain-inspiration

## Search radius
wide (any Mathlib domain)

## Context (read these files first)
- `analogies/fbc-mate-reencode.md` — a PRIOR cross-domain analysis (iter-034) that ALREADY prescribed
  the conjugate re-encoding cure. Read it in full: it concludes "Mathlib's API is sufficient, no gap-fill
  needed; the only project-side work is re-encoding the comparison object proof-free."
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — the live file. Key anchors:
  - `pushforwardBaseChangeMap` (~L79) — DEFINED as a `(g^*⊣g_*)` adjunction transpose.
  - `base_change_mate_gstar_transpose` (theorem ~L2042, sorry ~L2167) — the live residual.
  - `base_change_mate_codomain_read_legs` (~L1210), `base_change_mate_fstar_reindex_legs_conj`
    (~L1647, sorry ~L1700) — the comparison object + the stuck reframing crux.
  - `affineBaseChange_pushforward_iso` (~L2317, a SECOND sorry ~L2348 = the affine/locality reduction) and
    `flatBaseChange_pushforward_isIso` (~L2357) — the downstream targets `gstar_transpose` feeds.

## Structural problem (abstracted)
We must prove the affine i=0 flat-base-change comparison `g^* f_* F ⟶ f'_* g'^* F` (Stacks 02KH part 2) is
an isomorphism, for `Spec`-affine schemes. Iso-ness is already free (it is `conjugateIsoEquiv adjL adjR` of
`gammaPushforwardNatIso`). The OPEN obligation is a COHERENCE: identifying that abstract conjugate iso with
the concrete canonical sheaf map, which bottoms out at `base_change_mate_gstar_transpose` — the mate
identity equating the geometric `g^*`-transpose (conjugated by the `pullback_spec_tilde_iso` dictionaries)
with the algebraic extend/restrict counit reindexing. This coherence has been STUCK for 5+ iterations.

## Failed approaches
- **Element/`ext` evaluation.** `pushforwardBaseChangeMap` is DEFINED as an adjunction transpose, so any
  element-level evaluation unfolds (`Adjunction.homEquiv_counit`) straight back to the mate form
  `gstar_transpose` — it renames the gap, does not bypass it (documented dead end FlatBaseChange.lean:2097).
- **Conjugate-side assembly at the locked literal** (`conj-2a` section-composite reframing): the comparison
  object `codomain_read_legs` carries explicit leg-equality proofs `hfst/hsnd` (`pullback.fst/snd` only
  PROPOSITIONALLY equal to `e.hom ≫ Spec ιA`), so every `rw [hfst]`/`subst` fails with "motive is not type
  correct" (dependent-motive wall). 5-iter stall.
- **The `huce` master identity + assembly glue** (steps a/b/c): steps (b)/(c) and the `huce` counit-transport
  identity are PROVED and assembled, but the inline step-(a) reindex re-lands on the same `_legs_conj`
  dependent-motive wall; no inline route exists.
- **The fbc-mate-reencode.md prescription** (re-cut `codomain_read_legs` PROOF-FREE from `leftAdjointCompIso`
  / `pullbackComp` so `_legs` is a `conjugateEquiv.injective` identity): NEVER EXECUTED — it is a risky
  cascade through the assembled `gstar_transpose` scaffold, and the keystone it needs (conj-2b
  `reindex_conj_pullbackLeg` + conj-2d `reindex_conj_crossLayer` + the single-`conjugateEquiv`-component
  reframing) is unbuilt.

## The two questions I need answered (this is NOT a re-run of fbc-mate-reencode.md)
fbc-mate-reencode.md already established that the conjugate re-encoding is EXPRESSIBLE. The open strategic
question is whether it is the LOWEST-COST path. Specifically:

1. **Is the proof-free re-cut of `codomain_read_legs` genuinely safe and lower-cost than the alternatives?**
   Assess the cascade: re-typing `codomain_read_legs` changes the types of `_legs`, `inner_value_eq`, and
   everything `gstar_transpose` consumes. Is there a Mathlib idiom (e.g. building the comparison via
   `leftAdjointCompIso` from the START, behind a `def` whose `hfst/hsnd` never enter the type) that contains
   the cascade to a single re-stated `_legs`, leaving the downstream `huce` assembly intact? Cite the exact
   Mathlib lemmas (`CompositionIso.lean`, `Mates.lean`) and a concrete re-encoding shape.

2. **Is there a DIFFERENT Mathlib-precedented route to the affine i=0 base-change iso that bypasses
   `gstar_transpose` ENTIRELY?** Search wide. Candidates to evaluate: (a) prove the comparison iso directly
   at the level of the underlying `R`/`R'`/`A`-modules via the `regroupEquiv` tensor identity
   `(A⊗_R R')⊗_A M ≅ R'⊗_R M` (already DONE) and a `Spec`-level `widetilde`/`Γ` dictionary, never forming
   the categorical mate; (b) Mathlib's projection-formula / `Spec`-pushforward-base-change infrastructure if
   any exists; (c) any existing formalization pattern for Stacks 02KH or the affine case of cohomology-and-
   base-change in Mathlib or known Lean projects. For each candidate, report whether the needed Mathlib API
   exists, the porting cost, and whether it sidesteps the dependent-motive wall.

## Output I want
A ranked recommendation: KEEP (execute the proof-free re-cut — give the concrete contained-cascade shape) vs.
PIVOT (name the alternative affine-iso route + its Mathlib support + porting cost). This decides the FBC route
for iter-039. Persist the analysis to `analogies/<slug>.md`.
