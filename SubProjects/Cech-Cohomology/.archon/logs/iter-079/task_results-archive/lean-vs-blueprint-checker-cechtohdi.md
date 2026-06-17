# Lean ↔ Blueprint Check Report

## Slug
cechtohdi

## Iteration
077

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks: `lem:pushforward_mapHC_cechComplexOnX` @11846, `lem:cechAugmented_to_acyclicResolutionInput` @11885, `lem:cech_computes_cohomology_affineCover` @11926)

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforward_mapHomologicalComplex_cechComplexOnX}` (chapter: `lem:pushforward_mapHC_cechComplexOnX`)
- **Lean target exists**: yes (lines 78–86)
- **Signature matches**: yes — `f : X ⟶ S`, `𝒰 : X.OpenCover`, `F : X.Modules`, returns iso of cochain complexes in `S.Modules`. Matches the blueprint prose exactly.
- **Proof follows sketch**: yes — blueprint says "additive `f_*` commutes with the alternating-coface construction"; the Lean proof delegates to `mapAlternatingCofaceMapComplexIso`, which in turn uses `Functor.map_sum` / `Functor.map_zsmul` to prove the differential-identity. Mathematical content matches.
- **Notes**: The proof goes through a project-local sub-helper `mapAlternatingCofaceMapComplexIso` (see Unreferenced declarations below). That helper is not named in the blueprint, which is fine given the level of informality; the blueprint proof sketch is adequate.

### `\lean{AlgebraicGeometry.cechAugmented_to_acyclicResolutionInput}` (chapter: `lem:cechAugmented_to_acyclicResolutionInput`)
- **Lean target exists**: yes (lines 114–153)
- **Signature matches**: partial — the blueprint states two data items are produced ("an isomorphism `e` … and exactness in every positive degree") without specifying the Lean pairing type. The Lean signature returns `(F ≅ (cechComplexOnX 𝒰 F).cycles 0) ×' (∀ n, (cechComplexOnX 𝒰 F).ExactAt (n + 1))`, using `×'` (PProd) rather than `×` (Prod). The choice is forced by universe levels (the iso is `Type`-valued; `ExactAt` is `Prop`), but the blueprint does not specify or mention this. See **Red flags** for the directive flag.
- **Proof follows sketch**: yes — blueprint sketch (monomorphism from exactness at 0, epimorphism-onto-cycles from exactness at 1, then `Iso` assembly) matches the Lean proof structure (lines 130–153) step-for-step.
- **Notes**: The planner's embedded strategy comment in the Lean file (lines 91–106) is consistent with the actual proof; no stale-comment concern.

### `\lean{AlgebraicGeometry.cech_computes_higherDirectImage_of_affineCover}` (chapter: `lem:cech_computes_cohomology_affineCover`)
- **Lean target exists**: yes (lines 197–216)
- **Signature matches**: **no** — two hypotheses required by the proof body are absent from both the Lean signature and the blueprint statement:
  1. `[S.IsSeparated]` — required by `cechTerm_pushforward_acyclic` (see `CechTermAcyclic.lean` line 700) but absent from the capstone's hypothesis list (lines 197–200). Not mentioned anywhere in `lem:cech_computes_cohomology_affineCover` either.
  2. `hres : ∀ σ : Fin (p+1) → 𝒰.I₀, HasInjectiveResolutions (Scheme.Opens.toScheme (coverInterOpen 𝒰 σ)).Modules` — explicit positional argument of `cechTerm_pushforward_acyclic` (CechTermAcyclic.lean lines 703–704); not passed at the call site (line 207) and not stated as a hypothesis of the capstone.
- **Proof follows sketch**: **no** — the proof body (line 207) calls
  ```lean
  fun n => cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n
  ```
  but this call is **ill-typed**: `[S.IsSeparated]` cannot be synthesized (it is not in the local context) and `hres` (an explicit positional argument) is not provided. The theorem **does not type-check as written**. This matches the finding documented in `CechTermAcyclic.lean` lines 16–37, which explains that `S.IsSeparated` is mathematically necessary (counterexample: affine plane with doubled origin as `S`).
- **Notes**: `[HasInjectiveResolutions X.Modules]` is present in the capstone (line 197) and in `cechTerm_pushforward_acyclic`'s signature, so that part is fine. The two missing items (`[S.IsSeparated]` and `hres`) are both documented in `CechTermAcyclic.lean`'s module header, but were not propagated to the capstone's signature.

---

## Red flags

### Ill-typed proof body — missing explicit argument and unsatisfiable instance

- `cech_computes_higherDirectImage_of_affineCover` at line 207: the call
  ```lean
  fun n => cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n
  ```
  requires:
  - `[S.IsSeparated]` — typeclass; not in context (the capstone context contains `[X.IsSeparated]`, `[IsSeparated f]`, `[QuasiCompact f]`, but NOT `[S.IsSeparated]`); Lean will fail to synthesize.
  - `hres` — the last explicit argument `∀ σ : Fin (n+1) → 𝒰.I₀, HasInjectiveResolutions …`; not provided in the lambda. Lean will report "function expected" or arity mismatch.
  
  These two omissions make the theorem body **ill-typed**: the file will not compile. The LSP returned `success: false` with no elaborated errors, consistent with the file not having been built yet; static analysis of the callee's signature (CechTermAcyclic.lean lines 699–704) is conclusive.

### Signature divergence from callee's requirements

- The callee `cechTerm_pushforward_acyclic` was corrected this iteration to carry `[S.IsSeparated]` and `hres` (per CechTermAcyclic.lean lines 16–37, citing a concrete counterexample). Those corrections were not propagated to the capstone. This is not an excuse-comment situation, but it is a structurally broken chain.

### PProd vs Prod — directive flag

- `cechAugmented_to_acyclicResolutionInput` returns `×'` (PProd). The blueprint does not specify Prod vs PProd. The implementation choice is universe-correct (Iso is in `Type u`, ExactAt is in `Prop`), so this is not a wrong definition, but the blueprint is silent where it should give a concrete Lean hint. Classified as a blueprint adequacy gap rather than a Lean error.

---

## Unreferenced declarations (informational)

### `mapAlternatingCofaceMapComplexIso` (lines 59–74)
- No `\lean{...}` reference in the blueprint; no entry in `lem:pushforward_mapHC_cechComplexOnX`.
- Role: project-local helper used exclusively as the building block of `pushforward_mapHomologicalComplex_cechComplexOnX`. The docstring marks it "project-local helper".
- The name (`mapAlternating…`) is directly cognate to the blueprint's prose description "additive `f_*` commutes with alternating-coface complex"; a `\lean{...}` hint would help future provers but its absence is not a blocking gap given the small proof (single definitional unfolding + simp).
- **Recommendation**: add a `\lean{AlgebraicGeometry.mapAlternatingCofaceMapComplexIso}` note to the `lem:pushforward_mapHC_cechComplexOnX` proof sketch, or promote it to a standalone sub-lemma block.

---

## Blueprint adequacy for this file

- **Coverage**: 3/3 `\lean{...}` declarations present in the Lean file have a corresponding blueprint block. Unreferenced declarations: 1 helper (`mapAlternatingCofaceMapComplexIso` — acceptable); 0 substantive unlisted.
- **Proof-sketch depth**: **under-specified** for two blocks:
  - `lem:cech_computes_cohomology_affineCover`: the blueprint statement omits `[S.IsSeparated]` entirely (a hypothesis shown to be **mathematically necessary** by a concrete counterexample in CechTermAcyclic.lean lines 19–31). The blueprint proof (lines 11967–11996) also omits it. The blueprint for the sub-lemma `lem:cech_term_pushforward_acyclic` (lines 11685–11688) silently uses the affineness of `U_s ∩ f⁻¹(V)`, which requires `S.IsSeparated` (since `U_s ∩ f⁻¹(V) ≅ U_s ×_S V`; affineness of this fiber product requires the diagonal of `S` to be affine, i.e., `S.IsSeparated`), but the hypothesis is not stated.
  - `lem:cechAugmented_to_acyclicResolutionInput`: return type not specified (Prod vs PProd / universe level). Low impact given the obvious universe-mixing constraint, but a `\lean{...}` with the explicit type would be cleaner.
- **Hint precision**: **loose** for `lem:cech_computes_cohomology_affineCover` — the `\lean{...}` pin names the right declaration, but the informal statement it is pinned to omits a required hypothesis; a future prover copying the blueprint statement would write an ill-typed theorem.
- **Generality**: matches need for `pushforward_mapHomologicalComplex_cechComplexOnX` and `cechAugmented_to_acyclicResolutionInput`. `lem:cech_computes_cohomology_affineCover` is stated at the wrong level (missing `[S.IsSeparated]` makes it too weak / false as stated).
- **Recommended chapter-side actions**:
  - Add `[S.IsSeparated]` ("`S` is a separated scheme") to the hypotheses of `lem:cech_computes_cohomology_affineCover` and its proof, mirroring the correction already made in `CechTermAcyclic.lean`.
  - Add `[S.IsSeparated]` to `lem:cech_term_pushforward_acyclic` statement (line 11648); add a sentence explaining that `U_s ∩ f^{-1}(V) \cong U_s \times_S V` is affine because `S` is separated (so any affine-to-`S` map is affine).
  - Add a note about the `hres` (HasInjectiveResolutions for intersection opens) infrastructure gap, or, if that is to remain a Lean-only concern, document it with a `% NOTE:` in the blueprint.
  - Optionally add a `\lean{AlgebraicGeometry.mapAlternatingCofaceMapComplexIso}` note in `lem:pushforward_mapHC_cechComplexOnX`'s proof body.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| Capstone `cech_computes_higherDirectImage_of_affineCover` proof body is ill-typed: missing `[S.IsSeparated]` (unsatisfiable instance) and `hres` (explicit arg not passed) at line 207 | **must-fix-this-iter** |
| Blueprint `lem:cech_computes_cohomology_affineCover` statement omits `[S.IsSeparated]` — hypothesis is mathematically necessary (counterexample exists) | **must-fix-this-iter** |
| Blueprint `lem:cech_term_pushforward_acyclic` statement and proof silently use affineness of `U_s ∩ f^{-1}(V)` without stating `S.IsSeparated` | **must-fix-this-iter** |
| `cechAugmented_to_acyclicResolutionInput` uses `×'` (PProd); blueprint does not specify Prod/PProd | **minor** |
| `mapAlternatingCofaceMapComplexIso` has no blueprint block | **minor** |
| `hres` infrastructure gap undocumented in blueprint | **major** (blueprint should at least note the `HasInjectiveResolutions` gap for intersection opens) |

**Overall verdict**: The capstone theorem `cech_computes_higherDirectImage_of_affineCover` does not type-check as written (missing `[S.IsSeparated]` instance and `hres` explicit argument at the call to `cechTerm_pushforward_acyclic`), and the blueprint statement of the same theorem (and its key sub-lemma `lem:cech_term_pushforward_acyclic`) is mathematically incorrect by omitting the `[S.IsSeparated]` hypothesis — both the Lean and the blueprint sides require correction before this capstone can be closed.
