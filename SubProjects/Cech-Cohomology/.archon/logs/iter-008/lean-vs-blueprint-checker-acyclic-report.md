# Lean ↔ Blueprint Check Report

## Slug
acyclic

## Iteration
008

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

## Scope
Per directive: the **Cosyzygy section** (~lines 676–820 of the Lean file), plus the two blueprint frontier
leaves (`lem:acyclic_one_iso_coker`, `lem:acyclic_resolution_computes_derived`) that have not yet been
formalized. All four new Lean declarations verified axiom-clean via `lean_verify`.

---

## Per-declaration

### `\lean{CategoryTheory.Functor.cosyzygyShortExact}` (lem:cosyzygy_ses)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes
  - LSP signature: `(K : CochainComplex 𝒜 ℕ) (n : ℕ) (h : K.ExactAt (n+1)) : (cosyzygyShortComplex K n).ShortExact`
  - Blueprint: "for K exact at n+1 the cosyzygy SES `0 → Zⁿ → Kⁿ → Zⁿ⁺¹ → 0` is short exact" ✓
  - `K.ExactAt (n+1)` correctly encodes exactness at the degree mentioned.
- **Proof follows sketch**: yes
  - Blueprint: mono is immediate, epi by exactness (homology vanishes), exactness in the middle from kernel definition.
  - Lean: `exact_of_f_is_kernel _ (cosyzygyKernelFork K n)` + `mono_of_isLimit_fork` + `epi_toCycles_of_exactAt K n h`. Matches the three steps verbatim.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` — standard Mathlib only, no sorry.
- **notes**: `\leanok` present in blueprint. ✓

---

### `\lean{CategoryTheory.Functor.gCosyzygyIsoCocycles}` (lem:applied_cosyzygy_cycles)
- **Lean target exists**: yes (line 749)
- **Signature matches**: yes
  - LSP signature: `(G : 𝒜 ⥤ ℬ) [G.Additive] [PreservesFiniteLimits G] (K : CochainComplex 𝒜 ℕ) (n : ℕ) : G.obj (K.cycles n) ≅ ((G.mapHomologicalComplex ...).obj K).cycles n`
  - Blueprint: "G(Zⁿ) ≅ ker(G(Jⁿ) → G(Jⁿ⁺¹))". The RHS `.cycles n` of the applied complex is exactly `ker(G(dⁿ))`. ✓
  - `[PreservesFiniteLimits G]` is the correct Lean/Mathlib formalization of "left-exact / finite-limit-preserving". The blueprint says "additive left exact" — these are equivalent in this setting. ✓
- **Proof follows sketch**: yes
  - Blueprint: G preserves the kernel `iCycles n`, yielding the cycles iso.
  - Lean: `IsLimit.conePointUniqueUpToIso` applied to the limit-cone of preserved kernels. Correct formalization.
- **Axioms**: standard Mathlib only, no sorry.
- **notes**: `\leanok` present. ✓

---

### `\lean{CategoryTheory.Functor.cohomologyAppliedResolutionIso}` (lem:cohomology_of_applied_resolution — positive-degree part)
- **Lean target exists**: yes (line 793)
- **Signature matches**: yes
  - LSP signature: `(G : 𝒜 ⥤ ℬ) [G.Additive] [PreservesFiniteLimits G] (K : CochainComplex 𝒜 ℕ) (m : ℕ) : H^(m+1)(G(K)) ≅ cokernel (G.map (K.toCycles m (m+1)))`
  - Blueprint: `Hⁿ(G(J•)) ≅ coker(G(Jⁿ⁻¹) → G(Zⁿ))` for n ≥ 1. Setting n = m+1, the Lean cokernel argument is `G.map (K.toCycles m (m+1)) : G(Kᵐ) → G(K.cycles (m+1))`, i.e., `G(Jⁿ⁻¹ → Zⁿ)`. ✓
- **Proof follows sketch**: yes
  - Blueprint: homology is the cokernel of `toCycles`; rewrite via `gCosyzygyIsoCocycles`; post-composed iso doesn't change the cokernel.
  - Lean: `homologyIsCokernel` → `cokernel.mapIso` using `gCosyzygyIsoCocycles_toCycles`. Exactly this three-step argument.
- **Axioms**: standard Mathlib only, no sorry.
- **notes**: `\leanok` present on the block (covers both this decl and `gHomologyZeroIso`). ✓

---

### `\lean{CategoryTheory.Functor.gHomologyZeroIso}` (lem:cohomology_of_applied_resolution — degree-0 part)
- **Lean target exists**: yes (line 814)
- **Signature matches**: **partial**
  - Lean signature: `G.obj (K.cycles 0) ≅ H⁰(G(K))`
  - Blueprint states: `H⁰(G(J•)) ≅ G(A)`, with `A` the object being resolved.
  - The Lean gives `G(K.cycles 0) ≅ H⁰(G(K))` — direction reversed from the blueprint, and `K.cycles 0` appears in place of `A`. These are equivalent when `A ≅ K.cycles 0` (i.e., when K is an augmentation-dropped resolution of A), but the Lean type is strictly more general (it works for any cochain complex K with no augmentation hypothesis).
  - The doc comment acknowledges this: "Composed with an augmentation iso `A ≅ Z⁰` this gives the blueprint's `H⁰(G(J•)) ≅ G(A)`."
  - The blueprint block already contains a `% NOTE (iter-007 review)` explaining the split and naming both Lean decls, so this divergence is a known and documented design choice.
- **Proof follows sketch**: yes — `gCosyzygyIsoCocycles K 0 ≪≫ CochainComplex.isoHomologyπ₀`. The two-step argument (cycles iso then degree-0 homology iso) matches the blueprint proof's final sentence.
- **Axioms**: standard Mathlib only, no sorry.
- **notes**: The partial signature mismatch is benign and pre-documented. The downstream consumer (`rightDerivedIsoOfAcyclicResolution`) will need to compose with the augmentation iso; the blueprint proof sketch for TARGET-3 accounts for this (degree-zero case via `lem:cohomology_of_applied_resolution` + `R⁰G ≅ G`).

---

### `\lean{CategoryTheory.Functor.rightDerivedOneIsoCokerOfAcyclic}` (lem:acyclic_one_iso_coker) — FRONTIER LEAF
- **Lean target exists**: **no** — `lean_verify` returns "Unknown constant". Not present in the file.
- **Blueprint status**: has a complete statement block and proof sketch in the chapter (lines ~680–745 of .tex); no `\leanok` marker. Correctly un-marked.
- **Blueprint statement adequacy for a prover** (per directive): **adequate but slightly implicit about the Lean mechanism**.
  - The statement is clear: from `0 → A → J → Z → 0` with J acyclic, `(R¹G)(A) ≅ coker(G(J) → G(Z))`.
  - The proof sketch describes the LES segment `G(J) → G(Z) → (R¹G)(A) → 0` and identifies `δ⁰` as an epi whose kernel is `im(G(J) → G(Z))`.
  - **Gap**: the sketch doesn't say which Lean LES machinery to use. The pattern `δIso (k+1) (k+2)` from `rightDerivedShiftIsoOfSplitResolutionSES` doesn't directly apply at degree 0 (where the flanking middle-complex terms are not both zero). A prover needs to extract the cokernel iso from the epi/exact-sequence data of the LES, which requires a different tactic than the `δIso` used for the higher-degree shift. The blueprint could usefully add "use the exactness at `(R¹G)(A)` plus the zero right-end to produce the cokernel iso" and name the relevant Lean sequence-of-terms.
  - Overall: adequate in structure, under-specified in the concrete LES step.

---

### `\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}` (lem:acyclic_resolution_computes_derived = TARGET-3) — FRONTIER LEAF
- **Lean target exists**: **no** — `lean_verify` returns "Unknown constant". Not present in the file.
- **Blueprint status**: complete statement block and proof sketch; no `\leanok` marker. Correctly un-marked.
- **Blueprint statement adequacy for a prover** (per directive): **under-specified in the input type**.
  - The mathematical proof sketch is detailed and correct at the informal level (staircase induction: compose n-1 shift isos, close with the cokernel description, identify with cohomology).
  - **Gap 1 — Lean input type not pinned**: the status section of the Lean file suggests `J : CochainComplex 𝒜 ℕ`, `[∀ n, G.IsRightAcyclic (J.X n)]`, `A : 𝒜`, `π : (single₀).obj A ⟶ J` with `[QuasiIso π]`. The blueprint only says "a resolution of A with every Jⁿ right-G-acyclic"; it doesn't specify which Lean object encodes "the resolution is exact". A prover must choose between `QuasiIso`, an `InjectiveResolution`-style record, or an `ExactAt` hypothesis family. This choice affects all downstream sigma-type and pattern-matching. The blueprint should pin the input encoding.
  - **Gap 2 — Staircase composition**: the proof sketch lists the isos to compose but doesn't say how to handle the n=0 case (where the staircase is empty and `(R¹G)(A) = (R¹G)(Z⁰)` directly). At the Lean level, this case split requires an explicit `Nat.rec` or `match`; the blueprint is silent on this.
  - **Gap 3 — Identification with cosyzygy structure**: the final step "Lemma lem:cohomology_of_applied_resolution identifies this cokernel with the cohomology of the applied complex" needs to use `cohomologyAppliedResolutionIso` (whose type involves `K.toCycles m (m+1)`) whereas `acyclic_one_iso_coker` involves the surjection `G(J) → G(Z)`. Connecting these requires unfolding the cosyzygy structure; the blueprint doesn't spell out this bridge.
  - Overall: **major under-specification** — the proof strategy is sound but missing the input-type decision and several Lean-specific bridge steps.

---

## Red flags

No red flags found in the Cosyzygy section (lines 676–820):
- No `:= sorry` anywhere in the section.
- No suspect bodies (`:= True`, `:= rfl` on non-trivial claims).
- No excuse-comments (`-- TODO replace`, `-- temporary`, `-- wrong but works`).
- No `axiom` declarations. The `noncomputable` annotations are expected for category-theoretic constructions.
- The only workaround comment in the section (the "Clean-domain degree-0 augmentation" comment for `ιC0`) is pre-existing infrastructure from the horseshoe section and is correctly motivated by Lean's universe/domain unification constraints.

---

## Unreferenced declarations (informational)

The following Cosyzygy-section declarations have no `\lean{...}` blueprint reference. All are internal helpers:

| Declaration | Role | Blueprint-notable? |
|---|---|---|
| `cosyzygy_iCycles_comp_toCycles` | vanishing lemma for the short complex zero composite | No — technical lemma |
| `epi_toCycles_of_exactAt` | epimorphism of the corestriction | No — infrastructure for `cosyzygyShortExact` |
| `cosyzygyKernelFork` | kernel limit data for `iCycles` as kernel of `toCycles` | No — glue lemma |
| `Functor.cosyzygyShortComplex` | packages the cosyzygy triple into a `ShortComplex` | Minor — could be `\lean{}`-referenced from lem:cosyzygy_ses |
| `Functor.gCosyzygyIsoCocycles_hom_iCycles` | compatibility of cycles iso with `iCycles` | No — used only in the next lemma |
| `Functor.gCosyzygyIsoCocycles_toCycles` | naturality of cycles iso with `toCycles` | Minor — needed for `cohomologyAppliedResolutionIso` but not previewed in the blueprint proof sketch |

The notable one is `gCosyzygyIsoCocycles_toCycles`: the blueprint proof of lem:cohomology_of_applied_resolution says "rewrites that corestriction as `G(Jᵐ ↠ Zᵐ⁺¹)` post-composed with an isomorphism" without showing why that rewrite holds. In Lean this naturality square is non-trivial (see line ~773–782) and had to be discovered by the prover. This is a minor blueprint adequacy gap.

---

## Blueprint adequacy for this file

**Coverage**: 3/3 blueprinted cosyzygy declarations have a `\lean{...}` block and a complete Lean formalization. 6 unreferenced helpers are all internal infrastructure. The 2 frontier-leaf declarations (`rightDerivedOneIsoCokerOfAcyclic`, `rightDerivedIsoOfAcyclicResolution`) are correctly un-marked.

**Proof-sketch depth**: **adequate for the three formalized cosyzygy blocks**; **under-specified for the two frontier leaves** (see per-declaration entries above).
- `cosyzygyShortExact`: sketch gives mono / epi / exactness in middle — sufficient.
- `gCosyzygyIsoCocycles`: sketch gives left-exactness preserves the kernel — sufficient, though `gCosyzygyIsoCocycles_toCycles` required extra work.
- `cohomologyAppliedResolutionIso` + `gHomologyZeroIso`: sketch outlines the kernel/image/cokernel argument — sufficient, though the naturality square was implicit.
- `rightDerivedOneIsoCokerOfAcyclic`: sketch is correct but silent on the Lean LES mechanism for degree-0 cokernel extraction.
- `rightDerivedIsoOfAcyclicResolution` (TARGET-3): input type unspecified; n=0 staircase case unaddressed; bridge from `cohomologyAppliedResolutionIso` to `acyclic_one_iso_coker` not spelled out.

**Hint precision**: **precise** for the three formalized blocks. For the frontier leaves: `rightDerivedOneIsoCokerOfAcyclic` and `rightDerivedIsoOfAcyclicResolution` are named correctly and the statement prose is correct, but the Lean input-type for TARGET-3 needs to be fixed before proving.

**Generality**: **matches need** — all three formalized declarations work over a general `CochainComplex 𝒜 ℕ`, which is the right level of generality.

**Recommended chapter-side actions** (to be dispatched before TARGET-3 is attempted):

1. **Pin the input type for `rightDerivedIsoOfAcyclicResolution`**: add a `\lean{}`-annotated remark specifying the Lean signature — likely `(J : CochainComplex 𝒜 ℕ) [∀ n, G.IsRightAcyclic (J.X n)] (A : 𝒜) (π : (CochainComplex.single₀ 𝒜).obj A ⟶ J) [QuasiIso π]` or an equivalent. This is the single highest-value blueprint improvement.

2. **Add a proof-sketch bridge for `rightDerivedOneIsoCokerOfAcyclic`**: mention that the degree-0 cokernel iso is extracted via the LES exact segment `G(J) → G(Z) → (R¹G)(A) → 0` using `hSG.shortExact₃` (or the Lean analogue) to get an epi and `cokernel.desc` to construct the iso — distinct from the `δIso` path used for k ≥ 1.

3. **Add the `gCosyzygyIsoCocycles_toCycles` naturality square** to lem:cohomology_of_applied_resolution's proof sketch (one line: "naturality of the cycles iso with respect to `toCycles`"), so the blueprint previews the step rather than leaving it as an implicit "post-composed iso".

---

## Severity summary

| Finding | Severity |
|---|---|
| `gHomologyZeroIso` type gives `G(Z⁰) ≅ H⁰` rather than `H⁰ ≅ G(A)` directly; blueprint NOTE already documents this | **minor** |
| `lem:acyclic_one_iso_coker` block names `rightDerivedOneIsoCokerOfAcyclic` which does not yet exist in Lean; frontier leaf, intentional open work | **major** |
| `lem:acyclic_resolution_computes_derived` block names `rightDerivedIsoOfAcyclicResolution` (TARGET-3) which does not yet exist; frontier leaf | **major** |
| Blueprint for `rightDerivedIsoOfAcyclicResolution` under-specifies the Lean input type and omits n=0 staircase case / cosyzygy bridge — should be fixed before TARGET-3 is attempted | **major** |
| `gCosyzygyIsoCocycles_toCycles` compatibility lemma not previewed in blueprint; required extra prover work | **minor** |

No **must-fix-this-iter** findings. All new Cosyzygy declarations (lines 676–820) are axiom-clean, sorry-free, and faithfully match their blueprint blocks. The major findings are pre-existing open work (frontier leaves) and a blueprint adequacy gap for TARGET-3 that should be addressed before the next prover round attempts that theorem.

**Overall verdict**: the three Cosyzygy declarations added this iteration (`cosyzygyShortExact`, `gCosyzygyIsoCocycles`, `cohomologyAppliedResolutionIso`/`gHomologyZeroIso`) are a correct and complete formalization of their blueprint blocks, axiom-clean with no red flags; the chapter is adequate for the work done this iteration but needs the TARGET-3 input type pinned and the degree-0 cokernel mechanism spelled out before the frontier lemmas can be attempted.
