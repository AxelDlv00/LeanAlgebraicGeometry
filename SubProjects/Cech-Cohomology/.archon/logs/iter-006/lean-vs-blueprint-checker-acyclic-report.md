# Lean ↔ Blueprint Check Report

## Slug
acyclic

## Iteration
006

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

---

## Per-declaration

### `\lean{CategoryTheory.InjectiveResolution.isoRightDerivedObj}` (lem:right_derived_injective_resolution)
- **Lean target exists**: yes (Mathlib, `\mathlibok` present)
- **Signature matches**: N/A — Mathlib-provided, not in this file
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly marks with `\mathlibok`; no obligation in this file.

### `\lean{CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ}` (lem:right_derived_vanishes_injective)
- **Lean target exists**: yes (Mathlib, `\mathlibok` present)
- **Signature matches**: N/A — Mathlib-provided
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly marks with `\mathlibok`.

### `\lean{CategoryTheory.Functor.rightDerivedZeroIsoSelf}` (lem:right_derived_zero_iso_self)
- **Lean target exists**: yes (Mathlib, `\mathlibok` present)
- **Signature matches**: N/A — Mathlib-provided
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly marks with `\mathlibok`.

### `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₁, homology_exact₂, homology_exact₃, δ}` (lem:homology_long_exact_sequence)
- **Lean target exists**: yes (all four, Mathlib, `\mathlibok` present)
- **Signature matches**: N/A — Mathlib-provided
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly marks with `\mathlibok`.

### `\lean{CategoryTheory.Functor.IsRightAcyclic}` (def:right_acyclic)
- **Lean target exists**: yes (line 155, typeclass)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — definition block
- **notes**: Blueprint says `(R^{k+1} G)(J) = 0` for all `k ∈ ℕ`; Lean has `∀ k : ℕ, IsZero ((G.rightDerived (k+1)).obj J)`. Exact match. `\leanok` present on statement block, no sorry, standard axioms only.

### `\lean{CategoryTheory.Injective.instBiprod}` (lem:horseshoe_biprod_injective)
- **Lean target exists**: yes (Mathlib, `\mathlibok` present)
- **Signature matches**: N/A — Mathlib-provided
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly marks with `\mathlibok`.

### `\lean{CategoryTheory.ShortComplex.Splitting.ofHasBinaryBiproduct}` (lem:horseshoe_degree_split)
- **Lean target exists**: yes (Mathlib, `\mathlibok` present)
- **Signature matches**: N/A — Mathlib-provided
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly marks with `\mathlibok`.

### `\lean{CategoryTheory.mono_biprod_lift_factorThru_of_exact}` (lem:horseshoe_stage_mono)
- **Lean target exists**: yes (line 252)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint says: exact short complex with `S.f` mono, monos `α : S.X₁ ↪ P` (P injective), `γ : S.X₃ ↪ Q`, then `⟨factorThru(α, S.f), S.g ∘ γ⟩ : S.X₂ → P ⊕ Q` is mono. Lean has `{S : ShortComplex 𝒜} (hS : S.Exact) [Mono S.f] {P Q : 𝒜} [Injective P] (α : S.X₁ ⟶ P) [Mono α] (γ : S.X₃ ⟶ Q) [Mono γ] : Mono (biprod.lift (Injective.factorThru α S.f) (S.g ≫ γ))` — exact match. Proof follows the blueprint's preadditive cancellation argument (hx =≫ biprod projections, exactness lift, then mono α collapses). Axioms: {propext, Classical.choice, Quot.sound} only. `\leanok` on statement and proof blocks.

### `\lean{CategoryTheory.InjectiveResolution.horseshoeτ, horseshoeτ_cocycle, horseshoeβ, twistPair}` (lem:horseshoe_twist)
- **Lean target exists**: yes — all four present (lines 451, 455, 496, 430)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint states existence of augmentation `β : B → I_B^0` and twist family `τⁿ : I_C^n ⟶ I_A^{n+1}` with cocycle identity `τ^{n+1} ∘ d_C^n = -d_A^{n+1} ∘ τ^n`. Lean: `horseshoeτ` is the family (def, via `twistPair`), `horseshoeτ_cocycle` is the cocycle identity, `horseshoeβ` is the augmentation `ses.X₂ ⟶ I_A.cocomplex.X 0 ⊞ I_C.cocomplex.X 0`. `twistPair` is the recursion kernel. Blueprint proof sketch (induction on n, injectivity lifting) matches the `twistPair` recursion. `% NOTE` in blueprint correctly records the name decomposition (was formerly `ofShortExact_twist`). Axioms: standard only.

### `\lean{CategoryTheory.twistedBiprodD_comp}` (lem:horseshoe_dComp)
- **Lean target exists**: yes (line 309)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint says `d_B^{n+1} ∘ d_B^n = 0` by matrix multiplication and cocycle identity. Lean has `twistedBiprodD_comp (n : ℕ) : twistedBiprodD τ n ≫ twistedBiprodD τ (n+1) = 0` (given cocycle `hτ`), proved via `biprod.hom_ext`, `d_comp_d`, and `hτ n`. Direct match. `% NOTE` in blueprint records the injective-free abstraction to `twistedBiprod`. `\leanok` on statement and proof blocks.

### `\lean{CategoryTheory.twistedBiprodInl, twistedBiprodSnd, twistedBiprodSplitting, CategoryTheory.InjectiveResolution.horseshoeSES_shortExact}` (lem:horseshoe_chainMap)
- **Lean target exists**: yes — all four present (lines 331, 339, 357, 478)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint says coprojection `ι : I_A → I_B` and projection `π : I_B → I_C` are chain maps, with each degree split. Lean: `twistedBiprodInl : K ⟶ twistedBiprod τ hτ` (coprojection, degreewise `biprod.inl`), `twistedBiprodSnd : twistedBiprod τ hτ ⟶ L` (projection, degreewise `biprod.snd`), `twistedBiprodSplitting (n)` (each degree's `Splitting`), `horseshoeSES_shortExact` (assembles short exact sequence). Blueprint proof (biproduct column/row selections, degreewise splitness) matches the Lean's `biprod.hom_ext`-based proofs. `% NOTE` records the injective-free abstraction. `\leanok` on blocks.

### `\lean{CategoryTheory.InjectiveResolution.ofShortExact_resolvesMiddle}` (lem:horseshoe_resolvesMiddle)
- **Lean target exists**: yes (line 629)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint says `(I_B, β)` is an injective resolution of `B` (terms injective, exact in positive degrees, H⁰ ≅ B via β). Lean: `noncomputable def ofShortExact_resolvesMiddle : InjectiveResolution ses.X₂` — constructs the full `InjectiveResolution` record: `cocomplex := horseshoeMid`, injectivity by biproduct of injectives, `ι := horseshoeι`, `quasiIso := quasiIso_horseshoeι`. The blueprint proof (LES argument with flanking zeros) is reflected in Lean's approach via `quasiIso_τ₂`. Axioms: {propext, Classical.choice, Quot.sound}. `% NOTE (iter-006 review)` and `\leanok` present.

### `\lean{CategoryTheory.InjectiveResolution.ofShortExact}` (lem:injective_resolution_of_ses)
- **Lean target exists**: yes (line 643)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint says: given `0 → A → B → C → 0`, there exist injective resolutions I_A, I_B, I_C fitting into a degreewise-split short exact sequence of cochain complexes. Lean: `noncomputable def ofShortExact : InjectiveResolution ses.X₂ := ofShortExact_resolvesMiddle hses I_A I_C` — takes section-variable resolutions I_A, I_C, produces the middle resolution. This is the assembled horseshoe. Axioms: {propext, Classical.choice, Quot.sound}. `\leanok` on statement and proof blocks. `% NOTE (iter-006 review)` confirms axiom-cleanliness and removes the obsolete FALSE-DONE note from iter-004.

### `\lean{CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic}` (lem:acyclic_dimension_shift)
- **Lean target exists**: yes (line 661)
- **Signature matches**: **partial** — see below
- **Proof follows sketch**: partial — proof covers only part (1) of the blueprint's claim
- **notes**:
  Blueprint presents two parts:
  1. Connecting maps give isos `(R^k G)(Z) ≅ (R^{k+1} G)(A)` for all `k ≥ 1`.
  2. Base degree: `(R^1 G)(A) ≅ coker(G(J) → G(Z))`.
  Lean signature: `(G : 𝒜 ⥤ ℬ) [G.Additive] {ses : ShortComplex 𝒜} (hses : ses.ShortExact) [G.IsRightAcyclic ses.X₂] (k : ℕ) : (G.rightDerived (k+1)).obj ses.X₃ ≅ (G.rightDerived (k+2)).obj ses.X₁`.
  This formalizes **part (1) only** (with k+1 ≥ 1 for k : ℕ). Part (2) — the cokernel base case — is absent from the Lean declaration. The Lean file's own status note (lines 699–703) explicitly acknowledges this gap as outstanding infrastructure for TARGET 3.
  Additionally, the blueprint specifies G is "additive left-exact" but the Lean only requires `G.Additive` — the left-exactness hypothesis is not carried because part (2) is not formalized (part (1) holds for any additive G).
  Axioms: {propext, Classical.choice, Quot.sound}. No sorry.
  **Severity: major** — partial signature mismatch (part (1) formalized, part (2) missing; fixable by adding the cokernel companion or extending the declaration).

### `\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}` (lem:acyclic_resolution_computes_derived)
- **Lean target exists**: **no** — declaration does not exist in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A — TARGET 3, explicitly not built this iter
- **notes**: The `\lean{...}` hint points at a non-existent declaration. No `\leanok` on the blueprint block (as expected). The Lean file's status note (lines 695–713) describes this as TARGET 3 and lists the two outstanding sub-lemmas required: (a) part (2) of the dimension shift (cokernel base case for R¹G) and (b) cosyzygy SES infrastructure. **Severity: major** (dangling `\lean{...}` hint; expected given iter-006 scope but should be flagged for tracking).

---

## Red flags

### Placeholder / suspect bodies
None found. All declarations in the Lean file have genuine proof bodies — no `:= sorry`, `:= True`, `:= rfl` on non-trivial claims, or `:= Classical.choice _` placeholders. The four verified declarations (`ofShortExact`, `ofShortExact_resolvesMiddle`, `rightDerivedShiftIsoOfAcyclic`, `quasiIso_τ₂`) all use axioms {propext, Classical.choice, Quot.sound} only.

### Excuse-comments
None. The status block at lines 675–713 is a forward-looking project note, not an excuse for wrong or incomplete code. It accurately describes what is and isn't built. No `-- TODO replace with real def`, `-- temporary`, or `-- wrong but works for now` comments.

### Axioms on substantive claims
None unauthorized. All checked declarations use only {propext, Classical.choice, Quot.sound} — the standard Lean 4 axiom set. No file-level `axiom` declarations.

---

## Unreferenced declarations (informational)

Declarations in the Lean file with no corresponding `\lean{...}` blueprint entry, grouped by significance:

**Substantive — should eventually have blueprint blocks:**

| Declaration | Line | Note |
|---|---|---|
| `HomologicalComplex.HomologySequence.quasiIso_τ₂` | 89 | Homology four-lemma (τ₂ companion of Mathlib's `quasiIso_τ₃`). Full proof, no blueprint block. The `% NOTE` in `lem:horseshoe_resolvesMiddle` acknowledges this as `lean_aux`. |
| `CategoryTheory.Functor.rightDerivedShiftIsoOfSplitResolutionSES` | 224 | Resolution-level dimension shift; feeds both `rightDerivedShiftIsoOfAcyclic` and (eventually) TARGET 3. No blueprint block. |
| `CategoryTheory.InjectiveResolution.horseshoeι` | 533 | Augmentation chain map `(single₀ B) ⟶ horseshoeMid`, central to `ofShortExact_resolvesMiddle`'s proof. Not individually named in blueprint. |
| `CategoryTheory.InjectiveResolution.quasiIso_horseshoeι` | 608 | Proves `horseshoeι` is a quasi-iso via `quasiIso_τ₂`. Not in blueprint. |
| `CategoryTheory.InjectiveResolution.horseshoeφ` | 596 | Morphism of SES `single₀(ses) ⟶ horseshoeSES` feeding `quasiIso_τ₂`. Not in blueprint. |

**Helper infrastructure — acceptable to omit from blueprint:**

`Functor.IsRightAcyclic.ofInjective` (instance, line 160), `Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic` (line 179), `shortExact_of_degreewise_splitting` (line 192), `shortExact_map_mapHomologicalComplex_of_degreewise_splitting` (line 204), `twistedBiprodD` / `twistedBiprod` / `twistedBiprodInl_comp_Snd` and simp lemmas (TwistedBiprod section), `horseshoeβ₁` (line 386), `horseshoeH` (line 394), `horseshoeτZero` (line 409), `horseshoeMid` (line 462), `horseshoeSES` (line 467), `horseshoeSES_splitting` (line 472), `ιC0`/`ιC0_comp_d`/`ιC0_comp_τZero` (auxiliary domain-fix wrappers), `horseshoeβ_comp_d` (line 509), `single₀_hom_ext` (private, line 524), `horseshoeφ_comm₁₂` / `horseshoeφ_comm₂₃` (lines 562, 578), various `@[simp]` projection lemmas.

---

## Blueprint adequacy for this file

**Coverage**: 12/15 `\lean{...}` blueprint entries point to existing declarations in this file or Mathlib. 1 entry (`rightDerivedShiftIsoOfAcyclic`) is a partial match. 1 entry (`rightDerivedIsoOfAcyclicResolution`) is a dangling hint (declaration not yet built). Additionally, the file has 5 substantive unreferenced declarations that should eventually have blueprint blocks.

**Proof-sketch depth**: Under-specified for two items.

1. **`lem:acyclic_dimension_shift`**: The blueprint proof sketch elaborates both part (1) and part (2) in detail. The Lean only provides part (1). The proof sketch is therefore ahead of the Lean — but the gap is acknowledged in the file's status note and listed as a requirement for TARGET 3. The blueprint should eventually be restructured to separate parts (1) and (2) as distinct lemmas or explicitly mark part (2) as outstanding.

2. **`lem:horseshoe_resolvesMiddle`** / proof of `ofShortExact_resolvesMiddle`: The blueprint proof (LES + flanking zeros argument) is a valid sketch, but the actual Lean proof goes through `quasiIso_τ₂` (a result that has no blueprint block). A reader following the blueprint would arrive at a different proof strategy than what the Lean implements (LES-plus-zigzag vs. quasi-iso transfer). The current blueprint sketch is adequate for motivating the result but does not guide the formalization path actually taken. Informational only — the Lean proof is correct.

**Hint precision**: Precise for all existing declarations. The only imprecision is the dangling hint `\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}` pointing at a not-yet-built declaration (TARGET 3 announced); this is a tracking issue, not a precision failure.

**Generality**: Matches need for all formalized declarations. The `twistedBiprod` abstraction (injective-free) is a project-level generalization the blueprint did not anticipate; it is the right generalization and does not indicate blueprint narrowness.

**Recommended chapter-side actions** (for the blueprint-writing subagent):

1. **Add a `lean_aux` block for `quasiIso_τ₂`** (major). This is the homology four-lemma used as the engine of `ofShortExact_resolvesMiddle`. Statement: given φ : S₁ ⟶ S₂ a morphism of short exact sequences of complexes, if φ.τ₁ and φ.τ₃ are quasi-isos and the middle component is mono/epi at boundary degrees, then φ.τ₂ is a quasi-iso. Reference the Mathlib `quasiIso_τ₃` companion. The proof sketch in the Lean docstring (homology four-lemma windows of `composableArrows₅`, boundary mono/epi) can be transcribed directly.

2. **Add a `lean_aux` block for `rightDerivedShiftIsoOfSplitResolutionSES`** (major). This is the resolution-level intermediate dimension shift that feeds both `rightDerivedShiftIsoOfAcyclic` and TARGET 3. Statement: given a degreewise-split SES of injective resolutions `0 → I_A → I_J → I_Z → 0` with middle resolution of a right-G-acyclic object, connecting maps give `(R^{k+1} G)(Z) ≅ (R^{k+2} G)(A)`. It feeds the homology LES + vanishing flanking terms argument clearly and is reused by TARGET 3.

3. **Split `lem:acyclic_dimension_shift` into two sub-lemmas** (major): part (1) covering the shifting isos (currently formalized as `rightDerivedShiftIsoOfAcyclic`) and part (2) covering the cokernel base case (not yet built). The current unified presentation with `\leanok` on the block creates a false impression that both parts are done.

4. **Add blueprint coverage for the horseshoe intermediate constructions** `horseshoeι`, `quasiIso_horseshoeι`, `horseshoeφ` (minor). These are key intermediate constructions whose role (augmentation quasi-iso via morphism of SES) is underspecified in the current proof sketches of `lem:horseshoe_resolvesMiddle` and `lem:injective_resolution_of_ses`.

---

## Severity summary

| Finding | Severity |
|---|---|
| `lem:acyclic_dimension_shift` (partial): Lean covers only part (1) of a two-part blueprint lemma; part (2) cokernel base case not formalized | **major** |
| `\lean{rightDerivedIsoOfAcyclicResolution}`: dangling hint pointing at non-existent declaration (TARGET 3 not built) | **major** |
| `quasiIso_τ₂` has no blueprint block despite being a substantial project-local lemma | **major** |
| `rightDerivedShiftIsoOfSplitResolutionSES` has no blueprint block; key intermediate for TARGET 3 | **major** |
| `horseshoeι`/`quasiIso_horseshoeι`/`horseshoeφ` not individually named in blueprint proof sketches | **minor** |
| Blueprint proof of `lem:horseshoe_resolvesMiddle` does not preview the `quasiIso_τ₂` path actually taken | **minor** |

**No must-fix-this-iter findings.** All formalized declarations are axiom-clean (standard axioms only), sorry-free, and signature-correct for what they claim.

**Overall verdict**: The 14 formalized declarations for iter-006 are correct and axiom-clean; all `\lean{...}` hints pointing at in-file or Mathlib declarations resolve accurately. The main gap is that `lem:acyclic_dimension_shift` only partially covers its blueprint claim (part 1 of 2 formalized), and the chapter lacks blueprint blocks for three substantive project-local lemmas (`quasiIso_τ₂`, `rightDerivedShiftIsoOfSplitResolutionSES`, and the horseshoe augmentation cluster) that the blueprint-writing subagent should address before TARGET 3 begins.
