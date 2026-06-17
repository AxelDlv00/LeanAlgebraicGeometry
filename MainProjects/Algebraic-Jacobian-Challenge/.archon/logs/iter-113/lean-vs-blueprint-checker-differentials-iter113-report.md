# Lean ↔ Blueprint Check Report

## Slug
differentials-iter113

## Iteration
113

## Files audited
- Lean: `AlgebraicJacobian/Differentials.lean` (1041 lines)
- Blueprint: `blueprint/src/chapters/Differentials.tex` (251 lines)

## Summary of approach

This audit is bidirectional. I read every `\lean{...}` reference in the
chapter, located the corresponding declaration in the Lean, and
verified signature+content. I separately walked the Lean file and
flagged substantive declarations the chapter does not reference. Per
directive, the 5 named-deferred sorry sites and the 3 iter-112
must-fix signatures are reviewed against the iter-113 state.

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf}` (def:relative_kaehler_presheaf)
- **Lean target exists**: yes (L59)
- **Signature matches**: yes — `(f : X ⟶ S) : X.PresheafOfModules`, constructed via `pullbackPushforwardAdjunction.homEquiv.symm` of `f.c` and `DifferentialsConstruction.relativeDifferentials'`. Matches the chapter's "K\"ahler differential module of the ring map `O_S(f(U)) → O_X(U)`".
- **Proof follows sketch**: N/A (definition; chapter explains the construction informally and Lean realises it via Mathlib's `DifferentialsConstruction.relativeDifferentials'`).
- **notes**: Faithful to the chapter.

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheaf}` (thm:relative_kaehler_isSheaf)
- **Lean target exists**: yes (L277)
- **Signature matches**: yes — `Presheaf.IsSheaf (Opens.grothendieckTopology X.toTopCat) (relativeDifferentialsPresheaf f).presheaf`.
- **Proof follows sketch**: partial — Lean carries out Step 1 (forgetful reduction via `Presheaf.isSheaf_iff_isSheaf_comp` with `forget AddCommGrpCat`) and delegates Step 2+3 to the new helper chain `_isSheafOpensLeCover_type → _isSheaf_type`. The helper `_isSheafOpensLeCover_type` (L209) is closed by re-routing through `_isSheafUniqueGluing_type` (L168), which still carries a sorry. The chapter Route (a) (refinement-cofinality against `isSheaf_iff_isSheafOpensLeCover`) is the prose, but the Lean now pivots through the unique-gluing form. This is a **mathematical-content match in spirit but a route divergence in framing** — see "Blueprint adequacy" below.
- **notes**: The pivot to unique-gluing is mathematically legitimate (UniqueGluing → IsSheaf → IsSheafOpensLeCover via two framework Mathlib equivalences). It is NOT the previously-flagged wrong direction (the chapter L53 disavowal was about going *from* IsSheaf *to* IsSheafUniqueGluing as a basis-to-opens hook; the iter-113 Lean goes the other way and uses UniqueGluing as the *source* of mathematical content).

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentials}` (def:relative_kaehler_sheaf)
- **Lean target exists**: yes (L290)
- **Signature matches**: yes — `(f : X ⟶ S) : X.Modules`, packaging the presheaf with the sheaf axiom.
- **Proof follows sketch**: N/A (def).
- **notes**: OK.

### `\lean{AlgebraicGeometry.Scheme.universalDerivation}` (def:universal_derivation)
- **Lean target exists**: yes (L300)
- **Signature matches**: yes — `X.ringCatSheaf.presheaf ⋙ forget₂ RingCat AddCommGrpCat ⟶ (relativeDifferentials f).val.presheaf`. The chapter describes it as a morphism of sheaves of abelian groups `O_X → Ω_{X/S}`, which matches.
- **Proof follows sketch**: yes — uses `PresheafOfModules.DifferentialsConstruction.derivation'` for the local derivations + a naturality proof.
- **notes**: OK.

### `\lean{AlgebraicGeometry.Scheme.cotangentExactSeqAlpha}` (def:cotangent_alpha)
- **Lean target exists**: yes (L364)
- **Signature matches**: yes — `(f : X ⟶ Y) (g : Y ⟶ S) : (Scheme.Modules.pullback f).obj (relativeDifferentials g) ⟶ relativeDifferentials (f ≫ g)`.
- **Proof follows sketch**: yes — the Lean body explicitly executes the adjunction-bridge construction described in the blueprint's `lem:cotangent_exact_structure` proof (build a `Derivation'` on the pushforward target, then descend via the universal property of `relativeDifferentials'`).
- **notes**: OK.

### `\lean{AlgebraicGeometry.Scheme.cotangentExactSeqBeta}` (def:cotangent_beta)
- **Lean target exists**: yes (L602)
- **Signature matches**: yes — `(f : X ⟶ Y) (g : Y ⟶ S) : relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f`. Note that the chapter writes "β : Ω_{X/S} → Ω_{X/Y}" with the convention that "Y" plays the role of the intermediate scheme; the Lean's typing uses `relativeDifferentials f` (which is Ω over Y, since the second argument of `relativeDifferentials` is the target of `f`). This is consistent with the chapter's prose.
- **Proof follows sketch**: yes — uses the η-helper to descend via `isUniversal'.desc` on a derivation built from `derivation' φ_2'`.
- **notes**: OK.

### `\lean{AlgebraicGeometry.Scheme.cotangentExactSeq_structure}` (lem:cotangent_exact_structure)
- **Lean target exists**: yes (L679)
- **Signature matches**: yes — exhibits a witness `h : α ≫ β = 0`, exactness of the resulting `ShortComplex`, and epimorphism of `β`. Matches the lemma statement.
- **Proof follows sketch**: partial — `h_zero` and `h_epi` are closed; `h_exact` is the deferred sorry. Both closed branches follow the chapter's three-step decomposition (composition-zero via universal-property factorisation; epi via faithfulness of SheafOfModules → PresheafOfModules + `span_range_derivation`).
- **notes**: The deferred `h_exact` is acknowledged in the chapter at L121's `% NOTE` (deferred parallel to `instIsMonoidal_W` pending Mathlib infrastructure). Consistent.

### `\lean{SheafOfModules.epi_of_epi_presheaf}` (lem:sheafOfModules_epi_of_epi_presheaf)
- **Lean target exists**: yes (L634, `_root_.SheafOfModules.epi_of_epi_presheaf`)
- **Signature matches**: yes — `{F G : SheafOfModules R} (f : F ⟶ G) (h : Epi f.val) : Epi f`.
- **Proof follows sketch**: yes — uses `Functor.epi_of_epi_map` with the forgetful functor `SheafOfModules.forget R`, exactly as the chapter prescribes ("faithfulness of the forgetful functor … combined with the general fact that faithful functors reflect epimorphisms").
- **notes**: OK.

### `\lean{PresheafOfModules.Derivation.postcomp_comp}` (lem:derivation_postcomp_comp)
- **Lean target exists**: yes (L651, `_root_.PresheafOfModules.Derivation.postcomp_comp`)
- **Signature matches**: yes — `d.postcomp (f ≫ g) = (d.postcomp f).postcomp g` for a Derivation `d` and composable PresheafOfModules morphisms `f, g`.
- **Proof follows sketch**: yes — Derivation extensionality + `postcomp_d_apply` + `comp_app`.
- **notes**: OK.

### `\lean{AlgebraicGeometry.Scheme.cotangentExactSeqBeta_hη}` (lem:cotangent_exact_seq_beta_hη)
- **Lean target exists**: yes (L518)
- **Signature matches**: yes — `∃ η : (pullback (f≫g).base).obj S.presheaf ⟶ (pullback f.base).obj Y.presheaf, η ≫ φ_2' = φ_1'`, which is the η-coherence square described.
- **Proof follows sketch**: yes — explicit adjunction-chain construction (homEquiv + naturality), aligned with the chapter's description.
- **notes**: OK.

### `\lean{AlgebraicGeometry.Scheme.cotangent_exact_sequence}` (thm:cotangent_exact_sequence)
- **Lean target exists**: yes (L855)
- **Signature matches**: yes — existential bundle `∃ α β h, ShortComplex.Exact ∧ Epi β`.
- **Proof follows sketch**: yes — assembled from `cotangentExactSeq_structure` (consistent with chapter's "follows by bundling").
- **notes**: OK.

### `\lean{AlgebraicGeometry.Scheme.smooth_iff_locally_free_omega}` (thm:smooth_iff_locally_free_omega)
- **Lean target exists**: yes (L873)
- **Signature matches**: yes (REFACTORED THIS ITER) — now `(hfp : LocallyOfFinitePresentation f) (n : ℕ) : IsSmoothOfRelativeDimension n f ↔ ∀ x, ∃ U …, Module.Free R M ∧ Module.rank R M = n`. The previously-flagged free-`n` problem is fixed because `n` now appears on both sides of the iff. The Mathlib predicate is the chapter-prescribed `IsSmoothOfRelativeDimension`.
- **Proof follows sketch**: N/A (body is sorry; chapter has a substantive proof sketch but the prover work is named-deferred).
- **notes**: Minor: chapter says "finite-presentation morphism", Lean uses `LocallyOfFinitePresentation`. The distinction is "locally" vs "global"; for the equivalence statement this is the more permissive (and conventional Mathlib) hypothesis. Acceptable.

### `\lean{AlgebraicGeometry.Scheme.cotangent_at_section}` (cor:cotangent_at_section)
- **Lean target exists**: yes (L889)
- **Signature matches**: yes (REFACTORED THIS ITER) — now `(hfp : LocallyOfFinitePresentation f) (s : S ⟶ X) (hs : s ≫ f = 𝟙 S) (n : ℕ) (hsmooth : IsSmoothOfRelativeDimension n f) : ∀ x : S, ∃ U …, Module.Free R M ∧ Module.rank R M = n` where `M` is the section of the pullback `(Modules.pullback s).obj (relativeDifferentials f)`. The smoothness hypothesis correctly takes the rank from the `IsSmoothOfRelativeDimension n` predicate. Free-`n` problem fixed.
- **Proof follows sketch**: N/A (body is sorry; chapter has a proof sketch).
- **notes**: OK.

### `\lean{AlgebraicGeometry.Scheme.serre_duality_genus}` (thm:serre_duality_genus)
- **Lean target exists**: yes (L1033)
- **Signature matches**: **partial** (REFACTORED THIS ITER) — the cohomology-index mismatch is fixed: the LHS is now `H^0(Ω_{C/k})` (index 0) and the RHS is `H^1(O_C)` (index 1), matching the chapter prose `H^0(C, Ω_{C/k}) = H^1(C, O_C)`. **However**, two iter-112 issues are NOT addressed by the iter-113 refactor:
  - The hypothesis is still `[IsIntegral C.left]`, not "geometrically irreducible" (integrality of the base change to an algebraic closure). The chapter at L246 explicitly says "smooth proper **geometrically irreducible** curve".
  - The smoothness hypothesis is `hsmooth : Smooth C.hom` (dimension-free), not `IsSmoothOfRelativeDimension 1 C.hom`. The chapter says "curve", which conventionally is dimension 1, but the dimension is not pinned at the type level.
  These were both flagged in the iter-112 NOTE at L233–240; the iter-113 refactor only fixed the cohomology indices, leaving these other hypotheses untouched.
- **Proof follows sketch**: N/A (body is sorry).
- **notes**: The cohomology-index fix is the primary issue and is correctly addressed. The remaining hypothesis-strength gaps are reported below.

## Red flags

### Placeholder / suspect bodies
The 5 sorries are all named-deferred and individually documented; per directive these are not flagged as must-fix:
- L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` — NEW helper this iter; docstring contains a concrete iter-114+ recipe (universal property of `KaehlerDifferential` + structure-sheaf gluing + `span_range_derivation` uniqueness).
- L798 `cotangentExactSeq_structure` `case h_exact` — deferred parallel to `instIsMonoidal_W`, pending Mathlib `SheafOfModules.stalkFunctor` infrastructure.
- L880 `smooth_iff_locally_free_omega` — named-deferred.
- L897 `cotangent_at_section` — named-deferred.
- L1039 `serre_duality_genus` — named-deferred.

None of these are blueprint-claims-substantive-and-Lean-fakes-them violations; all five are tracked explicitly by chapter prose and `% NOTE` annotations.

### Excuse-comments
None. The `% NOTE` blocks in the chapter (L183–188, L209–212, L233–240) are review-agent annotations that document known refactor needs (and which the iter-113 refactor has now partly addressed for the cohomology indices). The Lean docstrings explaining the deferred sorries are workflow notes, not excuse-comments for wrong code.

### Axioms / Classical.choice on non-trivial claims
None.

## Unreferenced declarations (informational)

- `relativeDifferentialsPresheaf_obj_kaehler` (L90) — definitional-`rfl` helper exposing `Ω_{X/S}(V) = KaehlerDifferential (φ.app V)`. Helper; acceptable.
- `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (L168) — **NEW iter-113 helper, not referenced in blueprint**. The blueprint's L53 explicitly disavows a previous "wrong-direction" use of `IsSheafUniqueGluing`. The iter-113 use is the *correct* direction (UniqueGluing as the source of mathematical content, converting up to IsSheafOpensLeCover). The chapter should be updated to acknowledge this helper and its role in the proof route — see "Blueprint adequacy" below.
- `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (L209) — iter-112 helper; closed this iter via the unique-gluing chain. Not directly referenced in blueprint.
- `relativeDifferentialsPresheaf_isSheaf_type` (L245) — internal bridging helper; not referenced.
- `moduleKPresheafOfModules_obj`, `moduleKPresheafOfModules_smul_compat`, `moduleKPresheafOfModules_map`, `moduleKPresheafOfModules_map_forget₂`, `moduleKPresheafOfModules`, `moduleKPresheafOfModules_isSheaf`, `moduleKSheafOfModules` (L903–1023) — restriction-of-scalars scaffolding required by `serre_duality_genus` (the cohomology side wants `k`-modules, not `O_C`-modules). The blueprint chapter does not mention these explicitly; they are project-local infrastructure mirroring the analogous structures in `Cohomology/StructureSheafModuleK`. They could be promoted to a blueprint helper-block (or at least acknowledged in passing in §Serre duality) for completeness.

## Blueprint adequacy for this file

- **Coverage**: 14/25 substantive declarations have `\lean{...}` blocks. Unreferenced: 11 declarations, of which ~7 are unambiguous helpers (rfl-exposures, naturality lemmas, bridging definitions). The 4 borderline cases are the three new `_isSheafXxx_type` helpers (L168, L209, L245) and the `moduleK*` scaffolding (7 declarations forming a coherent unit).
- **Proof-sketch depth**: **mostly adequate, with one significant gap and one minor staleness**:
  - Significant: the chapter Route (a) prose (L33–53) describes the proof of `relativeDifferentialsPresheaf_isSheaf` as a refinement-cofinality argument against `isSheaf_iff_isSheafOpensLeCover`. The iter-113 Lean has pivoted to a third route: route the proof through the *unique-gluing* form via the framework Mathlib chain `isSheaf_of_isSheafUniqueGluing_types → IsSheaf.isSheafOpensLeCover`, then load the mathematical content into the unique-gluing helper (whose body invokes the universal property of `KaehlerDifferential` + structure-sheaf gluing + `span_range_derivation` uniqueness). This route is NOT prefigured in the chapter. The chapter's L53 explicitly disavowed a previous *wrong-direction* use of `IsSheafUniqueGluing`; the iter-113 use is the correct direction, but the chapter does not yet describe this route as an acceptable third path. A blueprint update is warranted.
  - Minor staleness: chapter L51's `[gap]` callout names routes (a) and (b) but not the iter-113 route via unique-gluing. The callout's spirit — "no off-the-shelf basis-to-opens lemma for `Scheme.PresheafOfModules`" — remains correct; what changes is that the iter-113 route bypasses the need for a basis-to-opens lemma entirely (by working at the level of arbitrary compatible families on arbitrary covers, which the unique-gluing form directly accommodates). The callout should be re-framed to acknowledge route (c).
- **Hint precision**: **mostly precise**. The three iter-112-flagged signature ambiguities (smooth iff Ω locally free; cotangent_at_section; serre_duality_genus) are now mostly resolved: the first two pin `IsSmoothOfRelativeDimension n f` correctly, the third pins the cohomology indices but the chapter prose's "geometrically irreducible curve" is still under-precise relative to a Mathlib-level `\lean{...}` hint and the dimension-1 hypothesis is implicit.
- **Generality**: matches need for the cotangent sequence + smoothness; the `moduleK*` parallel API for restriction-of-scalars is a parallel infrastructure track that the blueprint does not explicitly cover. Mentioning this scaffolding (e.g. via a short remark in §Serre duality) would tighten the bidirectional fit.
- **Recommended chapter-side actions**:
  - Update §Sheaf condition for $\Omega_{X/S}$ to add a route (c) acknowledging the unique-gluing pivot, citing the new helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` and the chain `isSheaf_of_isSheafUniqueGluing_types → IsSheaf.isSheafOpensLeCover` as framework Mathlib equivalences. The L51 `[gap]` callout should be re-framed to note that route (c) bypasses the need for a basis-to-opens lemma rather than supplying one.
  - Add a `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheafUniqueGluing_type}` block (statement-only; the body is currently a sorry deferred to iter-114+).
  - In §Serre duality, complete the iter-112 NOTE by also addressing the `IsIntegral` vs "geometrically irreducible" and `Smooth` vs `IsSmoothOfRelativeDimension 1` issues — either by relaxing the prose to match the Lean, or by dispatching a refactor lane to tighten the Lean to match the prose. The cohomology-index fix is in but the other two hypothesis-strength issues remain unresolved.
  - Optional: add a short `\begin{remark}` in §Serre duality acknowledging the `moduleK*` restriction-of-scalars scaffolding as a project-local pattern.

## Severity summary

- **must-fix-this-iter**: **none**. The iter-112 must-fix findings (free `n : ℕ` in `smooth_iff_locally_free_omega` and `cotangent_at_section`; `H^0 = H^0` in `serre_duality_genus`) are all addressed by the iter-113 refactor lane: the two `Smooth/IsSmoothOfRelativeDimension` signatures are correctly aligned, and the cohomology indices in `serre_duality_genus` are now `0 = 1`. The new helper at L168 carries a sorry but is correctly named-deferred, with an explicit iter-114+ recipe in its docstring.
- **major**:
  1. Blueprint-to-Lean route divergence: the chapter Route (a) prose (L33–53) does not describe the iter-113 unique-gluing pivot, even though the L168 helper is now the load-bearing piece of the sheaf-condition proof. Update the chapter to describe this route. (This is a blueprint adequacy gap, not a Lean error.)
  2. `serre_duality_genus` hypothesis-strength: `[IsIntegral C.left]` ≠ "geometrically irreducible"; `Smooth C.hom` ≠ `IsSmoothOfRelativeDimension 1 C.hom`. These were flagged in the iter-112 NOTE but not addressed by the iter-113 refactor (which scoped only to the cohomology indices). Either tighten the Lean or relax the chapter prose.
- **minor**:
  1. Chapter L51's `[gap]` callout should be re-framed to acknowledge the unique-gluing route as a third path.
  2. Add `\lean{...}` block for `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`.
  3. Add an explanatory remark in §Serre duality for the `moduleK*` scaffolding.
  4. Chapter says "finite-presentation morphism" for `smooth_iff_locally_free_omega` but the Lean uses `LocallyOfFinitePresentation`. Acceptable but worth pinning.

## Answers to directive-specific questions

1. **Is the chapter prose still consistent with the Lean's new shape (unique-gluing pivot)?** Partially. The Lean's direction (UniqueGluing → IsSheaf → IsSheafOpensLeCover, all framework Mathlib lemmas) is the *correct* direction; the chapter's L53 disavowal was about the OPPOSITE direction and remains accurate. However, the chapter's Route (a) prose does not yet describe the unique-gluing path as an acceptable third route, even though that's where the iter-113 mathematical content has now been parked. **Blueprint update is warranted.**
2. **Is the `[gap]` callout at L51 still load-bearing?** Yes in spirit, but the framing is now slightly stale. The callout correctly notes the absence of an off-the-shelf basis-to-opens lemma for `Scheme.PresheafOfModules`; the iter-113 route bypasses this need (by working at the unique-gluing level on arbitrary covers, where the gluing is internalised into the universal-property recipe). The callout should be re-framed to acknowledge route (c) rather than removed.
3. **Do the 3 refactored signatures now match the blueprint prose?**
   - `smooth_iff_locally_free_omega` (L873): **yes**. `IsSmoothOfRelativeDimension n f ↔ Ω locally free of rank n`, matches blueprint L189.
   - `cotangent_at_section` (L889): **yes**. `s^*Ω locally free of rank n` under `IsSmoothOfRelativeDimension n f`, matches blueprint L213.
   - `serre_duality_genus` (L1033): **partial**. The cohomology indices are correctly `0 = 1` matching `H^0(Ω) = H^1(O)` per blueprint L246–250. But `[IsIntegral]` ≠ "geometrically irreducible" and `Smooth` is dimension-free where the prose says "curve". Not must-fix this iter (the original `H^0 = H^0` blocker is gone), but flagged as **major** above.

## Overall verdict

The iter-113 refactor successfully resolved every iter-112 must-fix
finding (the three signature mismatches that made theorems
unsatisfiable). The new helper at L168 introduces a legitimate
unique-gluing pivot that is mathematically sound and correctly named-
deferred. The chapter prose now lags the Lean's new shape (route
divergence in §Sheaf condition; residual hypothesis-strength issues
in §Serre duality) — these are blueprint-side adequacy gaps, not
Lean errors, and should be addressed by a blueprint-writer dispatch
rather than blocking prover work.

14 declarations checked against `\lean{...}` blocks; 2 major findings,
4 minor findings; 0 must-fix-this-iter.
