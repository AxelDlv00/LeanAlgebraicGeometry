# Blueprint-writer directive — iter-054 — chapter Cohomology_CechHigherDirectImage.tex

You are updating ONE chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.
This chapter is the consolidated `% archon:covers` chapter for many files incl. the two new ones.
Do NOT touch any other chapter. Do NOT add `\leanok` (managed by sync_leanok). You MAY add
`\mathlibok` ONLY on a genuine Mathlib dependency anchor if you create one (see task 5; optional).

## Why this matters (context, do not transcribe into prose)
The progress-critic returned CHURNING on `cechAugmented_exact`: the target has been PARTIAL for 3
consecutive iters because the proof sketch describes the prepend-homotopy mathematically but never
names the Lean *mechanism* a prover must instantiate. A read-only Mathlib advisor (analogist) has now
identified the exact aligned Mathlib idioms — they are in `analogies/deepbridge.md` (READ IT FIRST,
it has decl names + signatures + imports). Your job is to fold those named mechanisms into the proof
sketches so the next prover lane has a precise route, and to clear the blueprint coverage debt.

## Task 1 — Expand Step 3 of the proof of `lem:cech_augmented_resolution` (the homotopy mechanism)
Current Step 3 prose (around TeX lines 7283–7320) correctly describes the prepend-`i_fix` contracting
homotopy but does NOT name how a prover converts it into `IsZero (homology p)` in Lean. Add a clearly
delimited sub-paragraph (keep the existing math prose; APPEND the mechanism) stating, in the project's
notation but naming the Lean route explicitly as formalization guidance:

  (a) The residual after Steps 1–2 + the sheafification site reduction is exactly
      `IsZero` of the homology (in every degree) of the *section cochain complex*
      `Γ(V, cechAugmentedComplex 𝒰 F)` (as a complex of abelian groups), for `V ≤ coverOpen 𝒰 i`.
  (b) This abstract complex `(GV.mapHomologicalComplex cc).obj Kp` (GV = evaluation-at-V through
      toPresheaf) is identified with the CONCRETE Čech section cochain complex
      `D = ∏_{σ} Γ(coverInter σ ⊓ V, F)` with the alternating-coface differential, via
      `Functor.mapHomologicalComplex` naturality plus a per-degree iso of the product-of-sections term.
      This is the same "L1 categorical→combinatorial" section-complex identification used elsewhere in
      the chapter (cross-reference `lem:cech_free_eval_*`); it is the project-side work of this step.
  (c) Because `V ≤ coverOpen 𝒰 i_fix`, prepending `i_fix` is the IDENTITY on each section term
      (`coverInter (i_fix ∷ σ) ⊓ V = coverInter σ ⊓ V`), so the prepend map gives a contracting
      homotopy `Homotopy (𝟙 D) 0` whose component maps are the combinatorial `combHomotopy i_fix` and
      whose relation `d∘h + h∘d = id` is exactly `combHomotopy_spec` (cross-reference
      `lem:cech_free_eval_prepend_homotopy` / its `_spec`).
  (d) A `Homotopy (𝟙 D) 0` forces `IsZero (D.homology p)` for every `p` via the three-lemma
      composition: `Homotopy.homologyMap_eq`, `HomologicalComplex.homologyMap_id`,
      `HomologicalComplex.homologyMap_zero`, and `IsZero.iff_id_eq_zero` (the last already used in this
      file's `isZero_of_faithful_preservesZeroMorphisms`).
  (e) DEAD END to record (one sentence): do NOT route via `ExtraDegeneracy` — Mathlib has only the
      SIMPLICIAL `SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv` producing a *ChainComplex*
      HomotopyEquiv (face maps), whereas the Čech complex here is a *cochain* complex (coface); there is
      no cosimplicial/cochain dual. Build the `HomologicalComplex.Homotopy` directly, mirroring the
      project's own `cechFreeComplex_quasiIso`.

Keep Step 4 (augmentation node) as is, but add one sentence: the same identification + homotopy covers
the augmentation/degree-0 term (the `i_fix`-component map `s ↦ s_{i_fix}` lands in `Γ(U_{i_fix}⊓V,F)=Γ(V,F)`).

## Task 2 — Add `\lean{}` blocks for the two NEW public helper lemmas (clears coverage debt)
Both are public, substantive, and used by `cechAugmented_exact`; both are currently DAG-`unmatched`.
Add two brief `\begin{lemma}…\end{lemma}` blocks (own labels), each with `\label`, `\lean{}`, a
one-line statement in project notation, a short `\uses`, and a one-line `\begin{proof}…\end{proof}`:

  (i)  `\lean{AlgebraicGeometry.isZero_of_faithful_preservesZeroMorphisms}` — a faithful functor that
       preserves zero morphisms reflects the property of an object being zero. Proof: `IsZero.iff_id_eq_zero`
       + `Functor.map_injective` + `map_id`/`map_zero`. (Pure category theory; no external source needed —
       Archon-original, so OMIT the `% SOURCE` lines.) Have `lem:cech_augmented_resolution` proof `\uses` it.

  (ii) `\lean{AlgebraicGeometry.isZero_presheafToSheaf_of_locally_isZero}` — a presheaf of abelian groups
       that is objectwise a zero object on a covering sieve has zero sheafification. Proof: wraps the
       Mathlib `isZero_presheafToSheaf_obj_of_isLocallyBijective` (already anchored in
       `lem:sheafify_kills_locally_zero`) into the "covering sieve of zero-fibre opens" form via local
       injectivity (from the fibrewise IsZero) + free local surjectivity (target zero). Archon-original
       packaging — OMIT `% SOURCE`. Place it adjacent to / `\uses`-linked from `lem:sheafify_kills_locally_zero`,
       and have `lem:cech_augmented_resolution` proof `\uses` it.

## Task 3 — Expand the proof of `lem:open_immersion_pushforward_comp` (name the 3 bridges)
The current proof (TeX ~7497–7559) is mathematically complete but does not name the Lean bridges. Per
the progress-critic the gap "may be near-rfl" — give the prover the named route so it attempts directly.
APPEND a "Formalization route" paragraph to the proof naming, in project notation:

  Bridge (1) — the cohomology-presheaf identification (the deferred hand-off in HigherDirectImagePresheaf):
    identify the objectwise homology `(pushforwardResolutionPresheafComplex f I).homology n` at `V` with the
    absolute cohomology presheaf `V ↦ Hⁿ(f⁻¹V, G) = Ext^n(jShriekOU(f⁻¹V), G)`, via the composite
    `InjectiveResolution.extAddEquivCohomologyClass` ∘ `CochainComplex.HomComplex.homologyAddEquiv.symm`
    (giving `Ext^n ≅ Hⁿ(Hom(X[0], I^•))`), then the project corepresentability
    `jShriekOU_homEquiv : (jShriekOU U ⟶ F) ≃+ Γ(U,F)` degreewise to turn the Hom-complex into the
    section/pushforward complex, with `InjectiveResolution.cochainComplexXIso` matching the ℕ/ℤ indexing.
    The `rightDerived` side is already settled by `InjectiveResolution.isoRightDerivedObj` (used at
    HigherDirectImagePresheaf:164). No abstract `rightDerived = Ext` comparison lemma is needed.
  Bridge (2) — Serre-vanishing transport to a general affine open: `affine_serre_vanishing` lives on
    `Spec R`; for affine `V`, `j⁻¹V` (resp. `U ∩ f⁻¹V`) is affine (`isAffineHom_of_affine_separated`
    gives `IsAffineHom j`, hence affine preimage), transported along its `isoSpec : j⁻¹V ≅ Spec Γ(j⁻¹V)`
    + naturality of absolute cohomology under that iso.
  Bridge (3) — locally-zero ⟹ sheafification zero for `PresheafOfModules.sheafification (𝟙)`: the analogue
    of `lem:sheafify_kills_locally_zero` (and the new `isZero_presheafToSheaf_of_locally_isZero`) for the
    module-sheafification, obtained by transporting across the `toSheaf∘sheafify ≅ presheafToSheaf∘forget`
    square (`PresheafOfModules.sheafificationCompToSheaf`), the "locally zero" hypothesis supplied by (1)+(2).

Also update the proof `\uses{}` to include the bridge ingredients it actually needs (e.g.
`lem:higher_direct_image_presheaf`, `lem:affine_serre_vanishing`, `lem:acyclic_resolution_computes_derived`,
and `lem:sheafify_kills_locally_zero`) so the DAG reflects the true dependency.

## Task 4 — Clear the `isAffineHom_of_affine_separated` coverage debt (bundling)
`isAffineHom_of_affine_separated` is a PRIVATE helper but currently shows as DAG-`unmatched`. Bundle its
name into the `\lean{...}` list of `lem:open_immersion_pushforward_comp` (the statement block already pins
the two public theorems; add the private helper name as a third `\lean{}` entry). The prose at item (1)
already justifies it ("j is an affine morphism").

## Task 5 — (optional Mathlib anchor) 
If convenient, you MAY add a one-line `\mathlibok` Mathlib-dependency anchor block stating
`InjectiveResolution.extAddEquivCohomologyClass` / `isoRightDerivedObj` in project notation with
`\lean{}` naming the real Mathlib decl, so the route's Mathlib reliance is visible in the DAG. Mark
`\mathlibok` ONLY on such an anchor, never on a project to-be-proved decl. This is optional.

## Constraints
- Source-of-truth for the named Mathlib decls: `analogies/deepbridge.md` (read it; it has exact names +
  imports). Do not invent decl names beyond what it lists + what the existing chapter/Lean already use.
- Keep prose mathematical; the named Lean decls are formalization guidance (acceptable as prose pointers).
- Preserve all existing `% SOURCE`/`% SOURCE QUOTE` blocks verbatim; only APPEND.
- Report any "Strategy-modifying findings" if the prose surfaces a strategic issue.
