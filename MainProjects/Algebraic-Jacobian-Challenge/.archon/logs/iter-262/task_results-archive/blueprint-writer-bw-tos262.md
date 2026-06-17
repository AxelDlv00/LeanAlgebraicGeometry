# Blueprint Writer Report

## Slug
bw-tos262

## Status
COMPLETE — both FIX 1 (`sliceDualTransport`/`dual_restrict_iso`) and FIX 2 (D3′
`pullback_tensor_map_basechange`) proof sketches now match the Lean.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### FIX 1 — `lem:dual_restrict_iso` / `sliceDualTransport`
- **Added lemma** `\lemma`/`\label{lem:slice_dual_transport}`/`\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}`
  (inserted immediately before the `lem:dual_restrict_iso` block) — states the per-`V`
  `𝒪_Y(V)`-linear iso `((pushforward β).obj (dual M.val))(V) ≅ (dual ((pushforward β).obj M.val))(V)`
  as a single `LinearEquiv.toModuleIso` packaging both legs.
  - Proof sketch added (Y): leg (A) built as the categorical image
    `(restrictScalars β_W).map (φ_•)` (with the load-bearing reason: a raw `ModuleCat.ofHom`
    reduces the carrier and loses the `restrictScalars`/`pushforward₀` module instance);
    leg (B) `codomainMap := inv (ε (restrictScalars g))`, `g := (f.appIso W).inv.hom` at the
    **`CommRingCat`** level, via `restrictScalars_isIso_ε_of_bijective` +
    `ConcreteCategory.bijective_of_isIso`, with the two resolved frictions phrased as the
    construction the prover follows ((a) keep `CommRing` native at `CommRingCat` level; the
    `forget₂`'d `restrictScalars` is `rfl`-equal so leg A's domain matches; (b) `𝟙_`-vs-section
    unit endpoints unify by definitional equality after `change`/`show` to the
    `𝟙_ (ModuleCat ↑(𝒪_Y(V)))` carrier — never elaborate the unit at the `forget₂`-composite
    carrier). Inverse/linearity/naturality via `f.appIso` round-trip + down-set bijection +
    `Subsingleton.elim`. Added inline `\lean{PresheafOfModules.dualUnitIsoGen}` at the named
    `dualUnitIsoGen` mention.
- **Revised** `lem:dual_restrict_iso` proof (the leg-(A) atom paragraph): retagged as the
  combined leg-(A)∘(B) atom referencing `\cref{lem:slice_dual_transport}`; replaced the
  "`eqToHom`-conjugation across `f.opensFunctor`" description with the categorical `.map` +
  `inv ε` description; documented leg (B) as now **unblocked**; **removed** the
  `% NOTE (review iter-261)` block; rewrote the "Step-4 residual" paragraph so it states
  `isoMk` is applied **directly** to `V ↦ sliceDualTransport f M V` (no separate leg-(B) step
  interposed in `isoMk`).

### FIX 2 — `lem:pullback_tensor_map_basechange` (D3′)
- **Revised** Sq1 paragraph: now named as the private sub-lemma
  `sheafificationCompPullback_comp`, with its statement form displayed (the four-factor
  `((sheafCompPb (h∘f)).app P).hom = (pullbackComp h f).inv ; h^*(...) ; ... ; a_Z.map(...)`)
  and the `leftAdjointUniq`/`homEquiv_leftAdjointUniq_hom_app` mate-calculus proof route (the
  δ-free twin of `lem:pullbackObjUnitToUnit_comp`). Marked it the **sole open ingredient**.
- **Revised** Sq4 paragraph: changed "absent from Mathlib and is the second standalone project
  sub-lemma" → "absent from Mathlib but **proved**" (factors through `sheafCompPb`, reducing to
  Sq1 + counit pseudofunctoriality).
- **Revised** the stale "genuinely missing ingredients" paragraph: now states the sole open
  ingredient is Sq1; Sq2b is fully discharged (axiom-clean), Sq3 + Sq4 are proved, Sq2
  reconciliation is `rfl`.
- **Added** the square-interleaving sentence: the four squares do not paste row-by-row because
  `S1_h` acts on `((pullback f).obj M) ⊗ ((pullback f).obj N)`, not on `pullback φ'_f (M⊗N)`,
  so factors slide past one another by `δ_natural`/NatTrans naturality (as in the D1′ paste).
- **Dropped** the stale `\uses{lem:tensorobj_restrict_iso}` from the
  `lem:pullback_tensor_map_basechange` statement block **and** its proof block (it is not used
  in the proof).

## Cross-references introduced
- `\uses{lem:slice_dual_transport}` added to the `lem:dual_restrict_iso` proof — target now
  defined in this same chapter (just above).
- `\cref{lem:slice_dual_transport}` used twice inside the `dual_restrict_iso` proof prose.
- `\cref{lem:pullbackObjUnitToUnit_comp}` referenced in the new Sq1 prose (already in the proof
  `\uses`; label defined in this chapter).
- Inline `\lean{PresheafOfModules.dualUnitIsoGen}` recorded at the prose mention.

## References consulted
- (No external-source citation blocks were added; the new `sliceDualTransport` lemma is a
  project-bespoke construction internal to `dual_restrict_iso`, which retains its existing
  Stacks `% SOURCE` block untouched.) Lean sources read for accuracy:
  `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` (`sliceDualTransport`,
  `dual_restrict_iso`), `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
  (`sheafificationCompPullback_comp`, `pullbackTensorMap_restrict`), and
  `analogies/ma-legb262.md` (leg-B `CommRing`/unit-defeq recipe).

## Macros needed (if any)
- None. All commands used (`\Scheme`, `\mathtt`, `\cref`, `\lean`, `\mathbf`) are already in use
  in this chapter.

## Notes for Plan Agent
- Minor source-vs-directive tension on Sq4: the in-`.lean` comments in
  `TensorObjSubstrate.lean` (iter-261, ~L2587–2593) still describe Sq4 (`pullbackValIso`
  composition coherence) as remaining work ("build Sq4, then run the interleaved merge"),
  whereas the directive states Sq4 is proved. I wrote the prose per the directive (Sq4 proved;
  Sq1 the sole open ingredient). If Sq4 is in fact not yet closed in Lean, the Sq4 paragraph
  and the "sole open ingredient" sentence will need a one-word walk-back; worth confirming the
  current Sq4 status before the next prover dispatch.
- `sheafificationCompPullback_comp` is `private` in the Lean; if a downstream chapter ever needs
  to `\lean{}`-reference it, it would have to be de-privatised. Not an issue for this chapter (it
  is named in prose only, not `\lean{}`-tagged).

## Strategy-modifying findings
None.
