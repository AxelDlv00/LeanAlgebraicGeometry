# Blueprint Review Report

## Slug
iter032

## Iteration
032

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:to_sheaf_preserves_epi`: `\uses{def:basis_cov_system}` appears in both the statement block and the proof block. The proof ("the forgetful functor is exact because it has both adjoints…") is purely categorical and does not involve `BasisCovSystem` at all. The `\lean{}` target `toSheaf_preservesEpimorphisms` is a category-level instance on sheaves of modules, not parameterized by a cover system. **wire-up** — remove `\uses{def:basis_cov_system}` from both blocks; the lemma has no project-internal dependencies. (soon severity — does not affect prover correctness, since Lean doesn't enforce `\uses{}` ordering.)

- `lean:AlgebraicGeometry.…` (1 isolated lean_aux node): Lean auxiliary helper with no blueprint entry and no blueprint edges. **keep** — lean_aux nodes are uncovered Lean helpers, not blueprint scaffolding. No action required.

- `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec` (2 blueprint nodes, `leandag show gaps`): No `\lean{}` hint on either. Both carry explicit `% NOTE` comments: these are transport-step descriptions, not standalone Lean declarations; the content is realized by transporting `cechEnginePrepend` / `cechEnginePrepend_spec` across `cechFreeEvalEngineIso`. **keep** — the design decision is documented and correct; no action required.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial (expected — AffineSerreVanishing, QcohTildeSections, P5a/P5b blocks are active/blocked phases; formalization ongoing)
- **correct**: true
- **notes**:
  - All blocks in AffineSerreVanishing focus area are formalize-ready (see Focus-area 1 below).
  - P1b `lem:isLocalizedModule_of_span_cover` is formalize-ready (see Focus-area 2 below).
  - P1a `lem:isQuasicoherent_restrict_basicOpen` and `lem:tilde_preserves_kernels` are well-formed, properly `% NOTE`-flagged project-to-build; not dispatched this iter. ✓
  - `lem:to_sheaf_preserves_epi` has a spurious `\uses{def:basis_cov_system}` — soon finding, see above.

---

## Focus-area 1: AffineSerreVanishing.lean gate

Blocks reviewed: `lem:affine_faces_mem`, `lem:standard_cover_cofinal`, `lem:affine_surj_of_vanishing`, `lem:to_sheaf_preserves_epi`, `def:affine_cover_system`, `def:basis_cov_system`, `lem:cover_datum_bridge`.

**`lem:affine_faces_mem`** (`AlgebraicGeometry.affine_faces_mem`)
- Statement: D(f)∩D(g) = D(fg) for Spec R; finite intersections of a standard cover's opens are again distinguished opens. This is the `faces_mem` field (condition 1) of the affine cover system.
- `\uses{}`: `def:standard_affine_cover` (mathlibok). Correct.
- Proof: D(f)∩D(g) = D(fg) by prime avoidance; iterate for arbitrary face. Proof block `\leanok`. ✓
- **FORMALIZE-READY.**

**`lem:standard_cover_cofinal`** (`AlgebraicGeometry.standard_cover_cofinal`)
- Statement: Standard covers of D(f) are cofinal among all open coverings of D(f): every open covering of D(f) admits a refinement that is a standard open cover. This is the cofinality input for Tag 009L.
- `\uses{}`: `def:standard_affine_cover`, `lem:scheme_isBasis_affineOpens` (both mathlibok). Proof block also uses `lem:affine_faces_mem`. Consistent.
- Proof: D(f) is quasi-compact; basic opens form a basis (lem:scheme_isBasis_affineOpens) → refine any covering to finite standard cover. Closure under intersection (lem:affine_faces_mem) establishes the 009L cofinality condition. Adequate for formalization.
- **FORMALIZE-READY.**

**`lem:affine_surj_of_vanishing`** (`AlgebraicGeometry.affine_surj_of_vanishing`)
- Statement: Let V be a distinguished open and 0→S₁→S₂→S₃→0 a SES of O_X-modules with Ȟᵖ(𝒰, S₁)=0 for every standard cover 𝒰 of V and p>0. Then S₂(V)→S₃(V) is surjective.
- `\uses{}`: `lem:ses_cech_h1`, `lem:standard_cover_cofinal`, `lem:to_sheaf_preserves_epi`, `lem:presheaf_is_locally_surjective`, `lem:sheaf_locally_surjective_iff_epi`, `lem:scheme_isBasis_affineOpens`. All correct; all prior-done inputs (ses_cech_h1, injective_cech_acyclic axiom-clean from iter-024/025; mathlib items present).
- Proof: Detailed 3-step argument. Step 1: g: S₂→S₃ is an epi of O_X-modules → underlying abelian-sheaf epi (lem:to_sheaf_preserves_epi) → locally surjective (lem:sheaf_locally_surjective_iff_epi + lem:presheaf_is_locally_surjective). Step 2: refine the local-surjectivity covering to a standard cover using lem:scheme_isBasis_affineOpens + lem:standard_cover_cofinal. Step 3: glue via Ȟ¹(𝒰, S₁)=0 using lem:ses_cech_h1.
- **FORMALIZE-READY.**

**`lem:to_sheaf_preserves_epi`** (`AlgebraicGeometry.toSheaf_preservesEpimorphisms`)
- Statement: The forgetful functor from O_X-modules to underlying abelian sheaves preserves epimorphisms.
- `\uses{}`: `def:basis_cov_system` (spurious — proof is pure category theory, no cover system). See soon finding above.
- Proof: The forgetful functor is exact (left adjoint composed with exact sheafification–forgetful) → sends the cokernel of g to the cokernel of its image → zero cokernel preserved → epi preserved.
- Statement is mathematically correct. Spurious `\uses{}` is a graph-cleanliness issue, not a math error.
- **FORMALIZE-READY** (the spurious \uses{} does not block the prover).

**`def:affine_cover_system`** (`AlgebraicGeometry.affineCoverSystem`)
- Statement: The affine cover system for Spec R: basis = distinguished opens D(f), admissible coverings = finite standard open covers of a distinguished open. Fields: faces_mem ← lem:affine_faces_mem; surj_of_vanishing ← lem:affine_surj_of_vanishing; injective_acyclic ← lem:injective_cech_acyclic (family-form, axiom-clean, applies to standard covers of any D(f)).
- `\uses{}`: `def:basis_cov_system`, `lem:affine_faces_mem`, `lem:affine_surj_of_vanishing`, `lem:injective_cech_acyclic`. Correct and complete.
- Note: `lem:injective_cech_acyclic` (family form, from CechBridge iter-025) is already axiom-clean. The `% NOTE` makes this explicit.
- **FORMALIZE-READY.**

**`def:basis_cov_system`** (`AlgebraicGeometry.BasisCovSystem, AlgebraicGeometry.CovDatum`)
- Per iter-028 memory notes, `BasisCovSystem` is already formalized (axiom-clean, part of the 01EO full chain). Not in `unmatched_lean`. ✓
- **ALREADY DONE.**

**`lem:cover_datum_bridge`** (`AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan`)
- Statement: For a standard affine cover from a spanning family s, coverOpen 𝒰 i = D(sᵢ) in Opens(Spec R).
- `\uses{}`: `def:standard_affine_cover`. Correct.
- Statement and proof blocks both `\leanok`. ✓
- **ALREADY DONE.**

**`\uses{}` chain acyclicity check**: `def:standard_affine_cover` (mathlibok) → `lem:affine_faces_mem` (leanok) → `lem:standard_cover_cofinal` → `lem:affine_surj_of_vanishing` → `def:affine_cover_system`. No cycle. All consumed inputs at each step are either mathlibok, leanok, or dispatched simultaneously in this iter. ✓

**HARD GATE — AffineSerreVanishing.lean: CLEARS.**

---

## Focus-area 2: QcohTildeSections.lean — P1b `lem:isLocalizedModule_of_span_cover`

**Statement** (`AlgebraicGeometry.isLocalizedModule_of_span_cover`):
- R commutative ring; M, N R-modules; g: M→N R-linear; f∈R; s: {1,…,n}→R with span(range s) = R.
- For each j: the map g_{sⱼ}: M_{sⱼ}→N_{sⱼ} (induced by g after localizing at powers of sⱼ) satisfies `IsLocalizedModule (powers f) g_{sⱼ}`.
- Conclusion: `IsLocalizedModule (powers f) g`.

**Correctness check**: The three `IsLocalizedModule` fields are:
1. f acts invertibly on N (every f^k: N→N bijective).
2. Every y∈N satisfies f^k·y = g(x) for some x∈M, k∈ℕ.
3. g(x)=g(x') implies f^k(x−x')=0 for some k∈ℕ.

All three follow from the local hypotheses via partition of unity (the sⱼ span the unit ideal). The statement is **mathematically correct**. The localization-of-a-module-map setup (`IsLocalizedModule (powers f) g_{sⱼ}` where g_{sⱼ}: M_{sⱼ}→N_{sⱼ}) is a standard Lean/Mathlib predicate application and is well-formed.

**Self-containedness**: All hypotheses are explicit. No implicit assumptions beyond standard Mathlib algebra. No `\uses{}` needed (pure commutative algebra over Mathlib's `IsLocalizedModule`). Correct to have no `\uses{}` for this block.

**Proof sketch adequacy for the three `IsLocalizedModule.mk` fields**:

- **Field 1 (f invertible on N)**: "Multiplication by f on N is an isomorphism iff it is so after localising at each sⱼ (injectivity and surjectivity are both local on a spanning cover)." — correct and sufficient. The locality of bijectivity on a spanning cover is a standard algebra fact.

- **Field 2 (surjectivity up to f-power)**: Explicit partition-of-unity construction: for each j, clearing sⱼ-denominator and f-denominator yields sⱼ^{aⱼ}·f^k·y = g(mⱼ); choose common k; sum with rⱼ from ∑rⱼsⱼ^{aⱼ}=1 gives f^k·y = g(∑rⱼmⱼ). Fully detailed.

- **Field 3 (equalizer)**: Set z = x−x' with g(z)=0; local IsLocalizedModule gives sⱼ^{bⱼ}·f^{kⱼ}·z=0 in M; take k=max kⱼ; sum with rⱼ from ∑rⱼsⱼ^{bⱼ}=1 gives f^k·z=0. Fully detailed.

All three clauses are worked out at a level that directly maps to `IsLocalizedModule.mk` in Lean. The key intermediate steps (locality of bijectivity, partition-of-unity argument, denominators-clearing via exact equalities in M) are all spelled out.

**HARD GATE — P1b `lem:isLocalizedModule_of_span_cover`: CLEARS.**

---

## P1a and tilde_preserves_kernels (NOT dispatched this iter)

**`lem:isQuasicoherent_restrict_basicOpen`**: Statement says F|_{D(f)} is quasi-coherent as an O_{Spec R_f}-module when F is quasi-coherent on Spec R. Well-formed. `% NOTE` correctly flags it as project-to-build (SheafOfModules restriction-to-basic-open machinery absent from Mathlib). Proof references `lem:exists_finite_basicOpen_subcover` (leanok, iter-031) and `lem:qcoh_iso_tilde_sections_of_presentation` (done). The proof strategy is sound (refine to finite basic-open cover, use widetilde-pullback, assemble). Not dispatched this iter. ✓

**`lem:tilde_preserves_kernels`** (`AlgebraicGeometry.tildePreservesFiniteLimits`): Statement: tilde functor M↦M̃ on Spec R is exact and preserves kernels/finite limits. Well-formed. `% NOTE` correctly flags it as project-to-build. Informal proof: stalkwise computation (stalk of M̃ at 𝔭 = M_𝔭), localization flat → M ↦ M_𝔭 exact → kernel-preserving → stalkwise isomorphism → isomorphism of sheaves. Proof is adequate when dispatched. Not dispatched this iter. ✓

---

## Dependency graph (leandag audit)

- `unknown_uses`: 0 — no broken `\uses{}` edges. ✓
- `unmatched_lean`: 41 entries — all expected (targets not yet formalized). The this-iter targets `standard_cover_cofinal`, `toSheaf_preservesEpimorphisms`, `affine_surj_of_vanishing`, `affineCoverSystem`, `isLocalizedModule_of_span_cover` are all in this list. ✓
- `isolated`: 1 node (lean_aux, no blueprint entry). **keep** — see above.
- `leandag show gaps`: 2 blueprint lemma nodes without `\lean{}` (`lem:cech_free_eval_prepend_homotopy`, `lem:cech_free_eval_prepend_homotopy_spec`). **keep** — intentionally no standalone `\lean{}` pin per explicit `% NOTE` comments. Content realized via transport from engine-level declarations.
- `conflicts`: 0. ✓

## Rendering integrity (blueprint-doctor)

`archon blueprint-doctor --json` returned clean:
- `malformed_refs`: [] ✓
- `broken_refs`: [] ✓
- `orphan_chapters`: [] ✓
- `covers_problems`: [] ✓
- `axiom_decls`: [] ✓

## Multi-route coverage

Single route (Route A — acyclic-resolution comparison). Route B was formally rejected. Blueprint coverage of Route A is adequate throughout the consolidated chapter. ✓

## Severity summary

**soon**:
- `Cohomology_CechHigherDirectImage.tex` / `lem:to_sheaf_preserves_epi`: spurious `\uses{def:basis_cov_system}` in statement and proof blocks. Wire-up disposition: remove both `\uses{}` references. The lemma is a standalone categorical instance with no project-internal dependencies. Not must-fix because (a) the prover can ignore false `\uses{}` edges, and (b) `def:basis_cov_system` is already formalized and the wrong-direction edge creates no dispatch-order hazard.

**informational**:
- 2 blueprint lemma nodes intentionally without `\lean{}` (transport steps, documented by `% NOTE`). No action required.
- 1 isolated lean_aux node. No action required.

**Overall verdict**: Blueprint is complete and correct for all blocks dispatched this iter. AffineSerreVanishing.lean and P1b (`lem:isLocalizedModule_of_span_cover`) both clear the hard gate. 0 must-fix-this-iter findings, 1 soon finding (spurious `\uses{}` in `lem:to_sheaf_preserves_epi`), 0 unstarted-phase proposals (all active phases have adequate blueprint coverage).
