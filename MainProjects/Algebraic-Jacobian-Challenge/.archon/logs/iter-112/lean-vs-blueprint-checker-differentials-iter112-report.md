# Lean ↔ Blueprint Check Report

## Slug
differentials-iter112

## Iteration
112

## Files audited
- Lean: `AlgebraicJacobian/Differentials.lean` (984 LOC)
- Blueprint: `blueprint/src/chapters/Differentials.tex` (233 LOC)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf}` (def:relative_kaehler_presheaf)
- **Lean target exists**: yes (L59).
- **Signature matches**: yes — `(f : X ⟶ S) : X.PresheafOfModules`. Built by transposing `f.c` through the pullback/pushforward adjunction and feeding into `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`. Matches the chapter's affine-chart description `Ω_{X/S}(V) = Ω_{B/A}` (also reified by helper lemma `relativeDifferentialsPresheaf_obj_kaehler` at L90).
- **Proof follows sketch**: N/A (definition).
- **notes**: clean, faithful realisation.

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheaf}` (thm:relative_kaehler_isSheaf)
- **Lean target exists**: yes (L220).
- **Signature matches**: yes.
- **Proof follows sketch**: yes (structurally) — the iter-112 body now explicitly enacts the chapter's three-step Route (a) recipe (Differentials.tex §28–§51):
    - Step 1 (forgetful reduction Ab → Type) is performed inline at L225 via `Presheaf.isSheaf_iff_isSheaf_comp _ _ (forget AddCommGrpCat)`. Faithful to chapter §33.
    - Steps 2 + 3 are packaged in the new helpers `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (load-bearing, L159, body `sorry`) and `relativeDifferentialsPresheaf_isSheaf_type` (derived, L188). Faithful to chapter §39–§51.
- **notes**: the main body is fully closed; the residual `sorry` lives in helper #1 only. The helper is intentionally not surfaced via `\lean{...}` (see "Unreferenced declarations" below).

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentials}` (def:relative_kaehler_sheaf)
- **Lean target exists**: yes (L233).
- **Signature matches**: yes — `(f : X ⟶ S) : X.Modules` (i.e. `SheafOfModules X.ringCatSheaf`). Bundles presheaf + sheaf condition via `⟨_, _⟩`.
- **Proof follows sketch**: N/A.
- **notes**: blueprint adds "It is quasi-coherent" but no separate `\lean{...}`-tagged statement formalises quasi-coherence. Acceptable as in-prose remark; flagged informationally below.

### `\lean{AlgebraicGeometry.Scheme.universalDerivation}` (def:universal_derivation)
- **Lean target exists**: yes (L243).
- **Signature matches**: partial — Lean returns a `NatTrans` of presheaves `X.ringCatSheaf.presheaf ⋙ forget₂ RingCat AddCommGrpCat ⟶ (relativeDifferentials f).val.presheaf` rather than a `Sheaf`-morphism. Mathematically equivalent (Sheaf is a full subcategory of Presheaf), but the blueprint's "morphism of sheaves of abelian groups" wording is a hair looser than the Lean's "natural transformation of presheaves". Minor.
- **Proof follows sketch**: N/A (constructive definition; the Leibniz/A-linearity wording in the chapter is realised by the `derivation'` builder + the `naturality` block at L254–261).
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.cotangentExactSeqAlpha}` (def:cotangent_alpha)
- **Lean target exists**: yes (L307).
- **Signature matches**: yes — `(Scheme.Modules.pullback f).obj (relativeDifferentials g) ⟶ relativeDifferentials (f ≫ g)` matches `f^*Ω_{Y/S} → Ω_{X/S}`.
- **Proof follows sketch**: yes — the body adjunction-transposes through `pullbackPushforwardAdjunction f` and constructs the descent via `isUniversal'.desc` against a custom `d_target` derivation; this faithfully realises the "Strategy" comment block at L312–323 and matches the chapter's local description in spirit.
- **notes**: closed; uses adjunction-coherence machinery prepared inline.

### `\lean{AlgebraicGeometry.Scheme.cotangentExactSeqBeta}` (def:cotangent_beta)
- **Lean target exists**: yes (L545).
- **Signature matches**: yes — `relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f`.
- **Proof follows sketch**: yes — descent via `isUniversal' φ1' .desc d1` against a derivation `d1` constructed from `d2 = derivation' φ_2'`, with the η-coherence supplied by `cotangentExactSeqBeta_hη`. Faithful to chapter §93–§103.
- **notes**: closed.

### `\lean{AlgebraicGeometry.Scheme.cotangentExactSeq_structure}` (lem:cotangent_exact_structure)
- **Lean target exists**: yes (L622).
- **Signature matches**: yes — `∃ (h : α ≫ β = 0), ShortComplex.mk α β h .Exact ∧ Epi β`.
- **Proof follows sketch**: partial — `h_zero` (vanishing) is closed via Route (c) (chapter §118–§119, faithful); `h_epi` is closed via Option (c) using `KaehlerDifferential.span_range_derivation` (chapter §123, faithful); `h_exact` is `sorry` at L741 — documented as deferred per chapter NOTE at L121 (parallel to `instIsMonoidal_W`).
- **notes**: directive instructs me not to flag the L622 `h_exact` sorry as it is named-deferred; the chapter prose at L121 + L126–§136 explicitly tracks it. Confirmed: prose still matches Lean signature here.

### `\lean{SheafOfModules.epi_of_epi_presheaf}` (lem:sheafOfModules_epi_of_epi_presheaf)
- **Lean target exists**: yes (L577).
- **Signature matches**: yes — root-level lemma reflecting epi from presheaf-of-modules to sheaf-of-modules via the faithful forgetful functor.
- **Proof follows sketch**: yes — exactly the "faithful functor reflects epis" argument the chapter §141 spells out.
- **notes**: closed; clean.

### `\lean{PresheafOfModules.Derivation.postcomp_comp}` (lem:derivation_postcomp_comp)
- **Lean target exists**: yes (L594).
- **Signature matches**: yes — root-level `[simp]` lemma stating `d.postcomp (f ≫ g) = (d.postcomp f).postcomp g` for derivations of presheaves of modules.
- **Proof follows sketch**: yes — by Derivation extensionality + `postcomp_d_apply`, matching chapter §147–§151.
- **notes**: closed.

### `\lean{AlgebraicGeometry.Scheme.cotangentExactSeqBeta_hη}` (lem:cotangent_exact_seq_beta_hη)
- **Lean target exists**: yes (L461).
- **Signature matches**: yes — existential `∃ η, η ≫ φ_2' = φ_1'` between the two adjoint-transposes of the comorphisms.
- **Proof follows sketch**: yes — η is built as `adj_fg.homEquiv.symm` of `g.c ≫ pushforward(g).map (adj_f.unit.app Y.presheaf)`, and the coherence is verified by injecting `adj_fg.homEquiv` and collapsing both sides through `(f ≫ g).c = g.c ≫ pushforward(g).map f.c`. Faithful to chapter §158–§163.
- **notes**: closed.

### `\lean{AlgebraicGeometry.Scheme.cotangent_exact_sequence}` (thm:cotangent_exact_sequence)
- **Lean target exists**: yes (L798).
- **Signature matches**: yes — `∃ α β h, ShortComplex.Exact ∧ Epi β`, faithful to the chapter's `f^*Ω_{Y/S} → Ω_{X/S} → Ω_{X/Y} → 0` exact sequence.
- **Proof follows sketch**: yes — assembled from `cotangentExactSeq_structure` via `obtain` + `exact`.
- **notes**: closed (modulo the `h_exact` sorry inherited transitively from `cotangentExactSeq_structure`).

### `\lean{AlgebraicGeometry.Scheme.smooth_iff_locally_free_omega}` (thm:smooth_iff_locally_free_omega)
- **Lean target exists**: yes (L816).
- **Signature matches**: **NO — substantive mismatch.** Blueprint (chapter §188): "f is smooth **of relative dimension n** if and only if Ω_{X/S} is locally free of rank n". The Lean uses `Smooth f` on the LHS, which is the dimension-free smoothness predicate (`AlgebraicGeometry.Smooth : (X ⟶ Y) → Prop`, no `n` parameter). The parameter `n : ℕ` only appears on the RHS. As stated, the biconditional reads `Smooth f ↔ (locally rank n)` for an arbitrary externally-fixed `n`, which is internally inconsistent: two different choices of `n` would give logically equivalent LHS but inequivalent RHS, which is not satisfiable for genus > 0 cases. The intended Mathlib predicate is `AlgebraicGeometry.IsSmoothOfRelativeDimension n f`.
- **Proof follows sketch**: N/A — body is `sorry` (L823).
- **notes**: this is a pre-existing mismatch (predates iter-112). Per directive guidance to flag if "chapter prose has drifted from the Lean signatures": the prose has not drifted, but the Lean signature has never matched the prose. Surfacing here because the per-declaration check rule is explicit ("using the wrong type class … is wrong, not approximate").

### `\lean{AlgebraicGeometry.Scheme.cotangent_at_section}` (cor:cotangent_at_section)
- **Lean target exists**: yes (L832).
- **Signature matches**: **NO — same substantive mismatch as above.** Blueprint (chapter §208): "If f is smooth **of relative dimension n** … then s^*Ω_{X/S} is locally free of rank n". Lean has `(hsmooth : Smooth f)` (dimension-free) plus a free `(n : ℕ)` parameter; nothing in the hypotheses ties `n` to the smoothness data. As stated the conclusion would have to hold for every `n : ℕ`, which is not what the corollary is claiming.
- **Proof follows sketch**: N/A — body is `sorry` (L840).
- **notes**: pre-existing, but flagged for the same reason as above. The fix mirrors the smooth_iff fix: replace `Smooth f` with `IsSmoothOfRelativeDimension n f` and drop the standalone `(n : ℕ)` (it then comes from the hypothesis).

### `\lean{AlgebraicGeometry.Scheme.serre_duality_genus}` (thm:serre_duality_genus)
- **Lean target exists**: yes (L976).
- **Signature matches**: **NO — substantive mismatch.** Blueprint (chapter §229–§230): `dim_k H^0(C, Ω_{C/k}) = dim_k H^1(C, O_C)`. The Lean states (L979–981):
  ```
  Module.rank k (HModule k (toModuleKSheaf C) 0) =
    Module.rank k (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0)
  ```
  Both sides use the cohomological index `0`. Since `HModule k F 0` is `H^0` (cf. `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:248`), the Lean asserts `dim H^0(O_C) = dim H^0(Ω_{C/k})`. For a smooth proper geometrically integral curve with `H^0(O_C) = k` (1-dimensional) and `H^0(Ω_{C/k}) = g` (genus-many dimensional), this is **false** for genus > 1. The Lean docstring at L971–975 in fact agrees with the blueprint (mentions H^0 vs H^1), so the docstring is also internally inconsistent with the signature.

  Additional minor signature gaps:
   - Blueprint says "geometrically irreducible curve"; Lean has `IsIntegral C.left` (irreducible + reduced over k, but not "geometrically" irreducible).
   - Blueprint says "curve" (relative dimension 1); the Lean carries no dimension hypothesis.
- **Proof follows sketch**: N/A — body is `sorry` (L982).
- **notes**: pre-existing structural mismatch. Even with the helper sheaves `moduleKSheafOfModules` correctly built, the equation as written cannot be the genus statement. Flagged per the bidirectional check rule.

## Red flags

### Placeholder / suspect bodies
- `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` at L159: body `sorry` packaging Step 2 + Step 3 of Route (a). Per directive guidance, this is acceptable scaffolding aligned with chapter §39–§51.
- `cotangentExactSeq_structure` `case h_exact` at L741: `sorry` deferred per chapter NOTE (L121, L126–§136) — named-deferred parallel to `instIsMonoidal_W`. Per directive guidance, not flagged.
- `smooth_iff_locally_free_omega` at L823: full-body `sorry`. Per directive guidance, not flagged as a sorry per se; the **signature mismatch** above is the substantive issue.
- `cotangent_at_section` at L840: full-body `sorry`. Same as above.
- `serre_duality_genus` at L982: full-body `sorry`. Same as above.

### Excuse-comments
None. The "iter-112 status" / "iter-082 status" / etc. comments are dated workflow notes attached to closed-or-sorried bodies, not excuses for wrong code. The "wrong but works for now" pattern is absent.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declaration; `Classical.choose` only appears as the standard `(cotangentExactSeqBeta_hη f g).choose` to extract a witness from a closed existential lemma — legitimate.

## Unreferenced declarations (informational)

Helpers (acceptable, no `\lean{...}` needed):
- `relativeDifferentialsPresheaf_obj_kaehler` (L90) — internal `rfl` reification of the affine sections of the presheaf.
- `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (L159) — Bar-B helper #1, intentionally private per Lean comment block at L98–157.
- `relativeDifferentialsPresheaf_isSheaf_type` (L188) — Bar-B helper #2, derived from #1.
- `moduleKPresheafOfModules_obj`, `moduleKPresheafOfModules_smul_compat`, `moduleKPresheafOfModules_map`, `moduleKPresheafOfModules_map_forget₂`, `moduleKPresheafOfModules`, `moduleKPresheafOfModules_isSheaf`, `moduleKSheafOfModules` (L846–966) — `k`-module restriction infrastructure consumed by `serre_duality_genus`. Plausible candidates for promotion to a lemma block in a future "Restriction of scalars" mini-section if the chapter wants finer accountability, but acceptable as helpers today.

No substantive declarations look like they should be in the chapter and aren't.

## Blueprint adequacy for this file

- **Coverage**: 14/14 `\lean{...}`-tagged blueprint blocks have a corresponding declaration in `Differentials.lean`. 11 unreferenced helpers (acceptable scaffolding) + 0 unreferenced substantive.
- **Proof-sketch depth**: adequate for `relativeDifferentialsPresheaf_isSheaf` (chapter §28–§54 give a precise three-step Route (a) recipe with named Mathlib hooks; the iter-112 Lean scaffolding mirrors the recipe step-for-step) and for the cotangent block. Adequate for `serre_duality_genus` only at the "this is Serre duality" level — the chapter does not preview the cohomology setup the Lean statement uses (`HModule k _ 0`), but since the proof body is `sorry` in any case, this is not yet load-bearing.
- **Hint precision**: **loose** in the smoothness block. The chapter prose explicitly says "smooth of relative dimension n", but the `\lean{...}` hints `AlgebraicGeometry.Scheme.smooth_iff_locally_free_omega` and `AlgebraicGeometry.Scheme.cotangent_at_section` ended up pinned to declarations that use the dimension-free `Smooth f` predicate. A tighter hint pinning the LHS to `AlgebraicGeometry.IsSmoothOfRelativeDimension` (or making the chapter explicit about which predicate to target) would have prevented the present mismatch.
- **Generality**: matches need for the cotangent-sequence portion; minor "too narrow" concern for `serre_duality_genus` since the chapter prose names "geometrically irreducible curve" and the Lean only carries `IsIntegral` + `IsProper` (no dimension-1 hypothesis, no `geometrically` upgrade).
- **Recommended chapter-side actions**:
  - In `thm:smooth_iff_locally_free_omega` and `cor:cotangent_at_section`, either expand the prose to acknowledge the planned predicate (`IsSmoothOfRelativeDimension n` vs `Smooth`) or add a `% NOTE:` flagging that the Lean side currently uses the dimension-free predicate and the rank parameter is decoupled.
  - In `thm:serre_duality_genus`, surface the H^0 vs H^1 asymmetry explicitly so a future prover sees the discrepancy on first read; add `% NOTE:` that the present Lean signature has both sides at index 0 and needs to be fixed to `H^0(Ω_{C/k}) = H^1(O_C)` (i.e., bump the second index from `0` to `1` and swap which sheaf carries which index, to match the prose).

## Severity summary

- **must-fix-this-iter**:
  - **Signature mismatch** in `smooth_iff_locally_free_omega` (L816): blueprint pins "smooth of relative dimension n" / Lean uses dimension-free `Smooth f` with a free `n : ℕ` parameter. Type class is materially wrong per the chapter's prose.
  - **Signature mismatch** in `cotangent_at_section` (L832): identical mismatch.
  - **Signature mismatch** in `serre_duality_genus` (L976): both Lean sides are `H^0`, blueprint and local docstring both assert `H^0 = H^1`. The Lean equation as written is mathematically false for genus > 1; the docstring contradicts the signature.

- **major**:
  - Blueprint hint precision: the `\lean{...}` hints in §183–§217 do not pin the smoothness predicate, contributing to the three signature mismatches above.

- **minor**:
  - `relativeDifferentials` (L233) has no separate `\lean{...}` for "It is quasi-coherent" — plausible to add a future `\lean{...}`-tagged corollary if/when the project formalises quasi-coherence here.
  - `universalDerivation` (L243) is typed as a presheaf-NatTrans rather than a Sheaf-morphism; mathematically equivalent but a sliver looser than the chapter's "morphism of sheaves of abelian groups".
  - `serre_duality_genus`: missing "curve" (dimension-1) and "geometrically" upgrades; minor relative to the `H^0/H^1` issue.

**Overall verdict.** The iter-112 scaffolding for the sheaf-of-Ω proof is faithful to the chapter's Route (a) recipe and integrates cleanly; the new helpers are sound packaging and not in need of `\lean{...}` exposure. The downstream smoothness corollaries (`smooth_iff_locally_free_omega`, `cotangent_at_section`) and `serre_duality_genus` carry pre-existing structural signature mismatches with the chapter prose that warrant must-fix-this-iter attention independent of their open `sorry` bodies.
