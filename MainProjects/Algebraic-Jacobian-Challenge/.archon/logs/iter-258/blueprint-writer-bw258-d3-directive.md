# blueprint-writer bw258-d3

## Task
Fix the Sq2/Sq2b paragraph of the D3′ proof sketch in
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, for
`lem:pullback_tensor_map_basechange` (`\lean{...pullbackTensorMap_restrict}`). Touch ONLY this chapter,
and within it ONLY the D3′ proof sketch (the Sq2 paragraph + the in-place `% NOTE:` directive the iter-257
review agent left at ~L3959–3971 instructing this rewrite).

## Two must-fix corrections (blueprint reviewer br258)

### (a) Stale prose — the ring-map reconciliation is DEFINITIONAL, not "non-trivial transport"
The current Sq2 prose describes the ring-map reconciliation
`(toRingCatSheafHom (h≫f)).hom = (toRingCatSheafHom f).hom ≫ (Opens.map f.base).op ◁ (toRingCatSheafHom h).hom`
as "non-trivial / transported by pseudofunctor coherence (`Opens.map_comp`)". This was DISPROVEN: the
project lemma `toRingCatSheafHom_comp_hom_reconcile` closes it by **`rfl`** at default transparency
(the `Opens.map`/`Scheme`-composition defeqs hold). Rewrite the paragraph so the reconciliation is
stated as a definitional fact (one line), NOT a scaffolding obligation — so a prover does not waste
effort building pseudofunctor-coherence machinery that is unnecessary.

### (b) Missing Sq2b sub-step — the genuine Mathlib-absent content
The genuine hard step ("Sq2b") is the **monoidality of `PresheafOfModules.pullbackComp`**: that the
connecting iso `pullbackComp φ'_f φ'_h : pullback φ'_f ⋙ pullback φ'_h ≅ pullback (φ'_f ≫ F.op ◁ φ'_h)`
intertwines the oplax tensorator δ of the single composite pullback with the composite oplax tensorator
`comp_δ` (= `G.map(δ_F) ≫ δ_G`) of `pullback φ'_f ⋙ pullback φ'_h`. Add a NAMED sub-step block (a
`\lemma` with `\label{lem:pullbackComp_monoidal}` or a clearly-delimited sub-step inside the proof) stating
this, with the proof route below.

**Proof route (from the cross-domain analogist, `analogies/d3sq2b258.md` — READ IT):** Sq2b is proved by
a **η→δ port of the already-compiling project lemma `pullbackObjUnitToUnit_comp`**
(`TensorObjSubstrate.lean:910`), stated at the **`PresheafOfModules` level** (NOT the Scheme/`forget₂`
level). Mathematically: the tensorator δ of `leftAdjointOplaxMonoidal` is the adjunction transpose
(`δ := homEquiv.symm` of the lax-monoidal pushforward's μ), so the SAME mate-calculus transpose argument
that closes the unit-coherence `pullbackObjUnitToUnit_comp` (with the unit η) ports directly with η
replaced by δ. The residual after transposing is the lax-μ composition coherence of
`PresheafOfModules.pushforward` across `pushforwardComp` — concrete/sectionwise (the η-twin
`unitToPushforwardObjUnit_comp` closes by `rfl`). The two-argument `tensorHom`/`δ_natural` bookkeeping is
the same as Mathlib's `CategoryTheory.Adjunction.isMonoidal_comp`. Working at presheaf level dissolves the
three iter-257 frictions (the `forget₂` monoidal-instance pin, the `(F:=F⋙G)` factorization, the reconcile
not firing) — note this in the prose. IMPORTANT (correct the record): iter-256's "the mirror recipe is
disproven" verdict was about the FULL 4-fold `pullbackTensorMap` (not a transpose); it does NOT bind Sq2b,
whose δ genuinely IS a transpose — so the η-twin mirror is the right route for Sq2b specifically.

Then the 4-square assembly (Sq1 `sheafificationCompPullback`-comp, Sq3 `sheafifyTensorUnitIso`, Sq4
`pullbackValIso`-comp) composes Sq2b with the ring-map reconcile (rfl) to give `pullbackTensorMap_restrict`.
Keep the existing Sq1/Sq3/Sq4 narrative; only fix Sq2 and insert Sq2b.

## Constraints
- This is a project-bespoke (Archon-original) categorical lemma — no external literature; carry the
  existing provenance style. No `% SOURCE QUOTE` invented.
- Do NOT add/remove `\leanok`/`\mathlibok` markers.
- Do NOT touch the `lem:dual_restrict_iso` / `sliceDualTransport` block (br258: it is complete + correct).
- Do NOT touch any other chapter or any other block in this chapter.
