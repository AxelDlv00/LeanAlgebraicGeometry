# Blueprint-reviewer report — iter-007

> **Audit date:** 2026-06-05
> **Subagent:** blueprint-reviewer
> **DAG snapshot:** 79 nodes · 119 edges · 12 with-sorry · 30 unmatched-lean · 0 unknown_uses · 0 isolated
> **Blueprint-doctor:** 0 malformed\_refs · 0 broken\_refs · 0 orphan\_chapters

---

## Overall verdict

**PASS.** The hard gate is cleared for iter-008 prover dispatch on both the FBC sub-lemma chain and the GF sub-lemma chain. All four QUOT-defs scaffold targets are individually correct and cleared. One advisory wire-up finding (not a must-fix) is noted below.

---

## 1 — Per-chapter checklist

### 1.1 Cohomology\_RegroupHelper.tex

| field | value |
|---|---|
| complete | **true** |
| correct | **true** |
| must-fix | none |

**Notes.** Single lemma `lem:base_change_regroup_linearEquiv`, `\leanok` on both statement and proof. Source citation (Stacks "Affine base change", boils-down step) present and correctly quoted. The chapter works in the `(A ⊗_R R') ⊗_A M` tensor orientation; the FlatBaseChange chapter works in the `(R' ⊗_R A) ⊗_A M` orientation — these are canonically isomorphic, and the FlatBaseChange proof note explicitly documents the bridge. No issues.

---

### 1.2 Cohomology\_FlatBaseChange.tex

| field | value |
|---|---|
| complete | **true** |
| correct | **true** |
| must-fix | none |

#### iter-006 must-fix: RESOLVED

The prior unsound one-liner (`LinearEquiv.toModuleIso (base_change_regroup_linearEquiv …)`) is replaced by a two-part argument:

1. **eT identity-A-linear bridge** — explicitly inserts the mandatory bridge between the two A-module tensor carriers `(A ⊗_R R') ⊗_A^{can} M` and `(A ⊗_R R') ⊗_A^{restr} M`. The bridge "re-reads the same generators against the carrier's A-action" and is described as "mathematically essential glue … it cannot be elided." This is the correct Lean type-theory insight: the two tensor products are definitionally distinct types even though their elements coincide. The new proof makes this explicit and formalizable. ✓

2. **Generator-wise R'-linearity check** — computes `(1 ⊗ r') · ((a ⊗ s) ⊗ m) = (a ⊗ (r's)) ⊗ m ↦ (r's) ⊗ (a·m) = r' · (s ⊗ (a·m))`, confirming R'-equivariance on generators. ✓

The proof is mathematically sound and the Lean obstacle is correctly diagnosed.

#### Three new sub-lemmas

**`lem:base_change_mate_unit_value`** (`\lean{AlgebraicGeometry.base_change_mate_unit_value}`)
- Statement: unit of the (g'⁎, g'\_∗)-adjunction on generator m maps to (1 ⊗ 1) ⊗ m in (R' ⊗_R A) ⊗_A M ✓
- `\uses{lem:base_change_mate_codomain_read, lem:pullback_spec_tilde_iso}` ✓
- Proof: correct (extension-of-scalars adjunction unit formula; naturality at the pullback dictionary identifies the elementary tensor) ✓
- No `\leanok` (not yet in Lean — consistent) ✓

**`lem:base_change_mate_fstar_reindex`** (`\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}`)
- Statement: applying f\_∗ = restr\_φ leaves m ↦ (1 ⊗ 1) ⊗ m unchanged on elements; pseudofunctor identities (g'f)\_∗ = g\_∗ f'\_∗ reindex the target to the codomain read (R' ⊗_R A) ⊗_A M ✓
- `\uses{lem:base_change_mate_codomain_read, lem:base_change_mate_unit_value}` ✓
- Proof: correct (restriction of scalars is identity on underlying sets; pushforward-composition + pushforward-congruence naturality) ✓
- No `\leanok` ✓

**`lem:base_change_mate_gstar_transpose`** (`\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}`)
- Statement: (g⁎ ⊣ g\_∗)-transpose of the unit assignment m ↦ (1 ⊗ 1) ⊗ m is `r' ⊗ m ↦ (r' ⊗ 1) ⊗ m`, scaling the R'-tensor factor ✓
- `\uses{lem:base_change_mate_domain_read, lem:base_change_mate_unit_value}` ✓
- Proof: correct (standard extension-of-scalars transpose formula: û(r' ⊗ m) = r' · u(m); substituting u(m) = (1 ⊗ 1) ⊗ m and using the R'-action on (R' ⊗_R A) ⊗_A M) ✓
- `% NOTE:` explicitly flags this stands on proof sketch with no external reference ✓
- No `\leanok` ✓

#### `lem:base_change_mate_generator_trace_eq` — thin assembly

Statement `\uses{def:pushforward_base_change_map, lem:base_change_mate_domain_read, lem:base_change_mate_codomain_read, lem:base_change_mate_regroupEquiv}`. Proof `\uses` additionally lists all three new sub-lemmas. The three-step assembly (A: unit value → C: pushforward/reindex → B: g⁎-transpose) correctly derives `r' ⊗ m ↦ (r' ⊗ 1) ⊗ m = regroup⁻¹`. ✓

**Advisory wire-up** (non-blocking): The STATEMENT `\uses{}` of `lem:base_change_mate_generator_trace_eq` omits `lem:base_change_mate_unit_value`, `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose`. These appear only in the PROOF `\uses{}`. As a result, `lem:base_change_mate_fstar_reindex` and `lem:base_change_mate_gstar_transpose` appear as **orphan leaves** in the dependency DAG (0 reverse-dependencies each), while the three sub-lemmas as a group appear disconnected from `lem:base_change_mate_generator_trace_eq` at the statement level. Recommended fix: add the three sub-lemmas to the STATEMENT `\uses{}` of `lem:base_change_mate_generator_trace_eq`. Does NOT block prover dispatch.

---

### 1.3 Picard\_FlatteningStratification.tex

| field | value |
|---|---|
| complete | **true** |
| correct | **true** |
| must-fix | none |

#### Three new sub-lemmas

**`lem:gf_clear_one_denominator`** (L4a) (`\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}`)
- Statement: For p ∈ K[X₁,…,Xₙ] (K = Frac(A)), ∃ g ≠ 0 in A s.t. p ∈ image of MvPolynomial.map (algebraMap (Localization.Away g) (FractionRing A)) ✓
- Lean signature comment matches statement exactly ✓
- Proof: Takes product g = s₁ · … · sᵣ of denominators of the finitely many non-zero coefficients. Since A is a domain, g ≠ 0 and each coefficient lies in A\_g. Sound. ✓
- SOURCE: Nitsure §4 with verbatim quote (L1755–1759) ✓
- No `\uses{}` (standalone, no blueprint dependencies — correct) ✓
- No `\leanok` ✓

**`lem:gf_generic_rank_ses`** (L5a) (`\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}`)
- Statement: A noetherian domain, N finite P\_d-module. ∃ m ∈ ℕ and injective P\_d-linear φ: P\_d^{⊕m} → N with torsion cokernel T. The generic rank m = Module.finrank (FractionRing P\_d) (LocalizedModule (nonZeroDivisors P\_d) N). **No element of A is inverted at this step** (explicitly flagged). ✓
- Lean signature comment matches statement and directive requirement (`m = finrank (FractionRing P_d) (LocalizedModule (nonZeroDivisors P_d) N)`) ✓
- Proof: Chooses Q-basis of N\_Q, clears denominators to lift to P\_d-elements v₁,…,vₘ ∈ N; P\_d-linear independence → φ injective; Q ⊗ T = 0 → T torsion. Sound. ✓
- SOURCE: Nitsure §4 with verbatim quote (L1760–1765) ✓
- No `\uses{}` (Hilbert basis theorem is a standard ring theory fact, unnamed in \uses{} — acceptable) ✓
- No `\leanok` ✓

**`lem:gf_torsion_reindex`** (L5b) (`\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}`)
- Statement: A noetherian domain, d ≥ 1, T finite torsion P\_d-module. ∃ g ≠ 0 in A, m' < d s.t. T\_g is finite over A\_g[X₁,…,X\_{m'}]. One may always take m' = d−1. ✓
- Lean signature comment: m' < d with m' = d-1 via single-variable elimination ✓
- Proof: Ann(T) contains nonzero F; Nagata change of variables makes F monic in X\_d up to leading coefficient g; invert g so division algorithm applies; A\_g[X₁,…,X\_{d-1}] finite over A\_g[X₁,…,X\_d]/(F); T\_g finite by transitivity. Sound. ✓
- SOURCE: Nitsure §4 with verbatim quote (L1766–1768) ✓
- `% NOTE:` about shared Nagata engine with L4 ✓
- No `\leanok` ✓

#### `lem:gf_noether_clear_denominators` (L4) — Finset-fold rewrite

`\uses{lem:noether_normalization_fg, lem:gf_clear_one_denominator}` ✓. The `% NOTE (iter-007 decomposition)` comment correctly characterizes the proof as a Finset-fold of `gf_clear_one_denominator` over the finite (generator, coefficient-polynomial) pairs, multiplying finitely many gᵢ into one common g ≠ 0. Mathematical structure matches the new sub-lemma. ✓

#### `lem:gf_polynomial_core` (L5) — thin assembly

STATEMENT `\uses{lem:gf_finite_module, lem:gf_splice_shortExact, lem:gf_torsion_base, lem:gf_splice_shortExact_free_transport, lem:gf_generic_rank_ses, lem:gf_torsion_reindex}` — all six sub-lemmas correctly wired at the STATEMENT level (not just proof level). ✓

The five-step inductive proof:
1. Generic-rank SES via `gf_generic_rank_ses` (no g-inversion here) ✓
2. Torsion reindex via `gf_torsion_reindex` (produces g ≠ 0 ∈ A and m' < d) ✓
3. IH at new base A\_g (explicitly: "the base ring of the induction must be allowed to change from A to A\_g") ✓
4. Descent from A\_g to A via `gf_splice_shortExact_free_transport` ✓
5. Splice via `gf_splice_shortExact` ✓

**`% LEAN PROOF STRUCTURE` note is mathematically sound and load-bearing.** The note correctly identifies that the strong induction must revert A into the motive (not just N), because `gf_torsion_reindex` changes the base ring from A to A\_g, and the IH must be applied at A\_g. This is the correct Lean formalization insight. ✓

---

### 1.4 Picard\_GrassmannianCells.tex

| field | value |
|---|---|
| complete | **true** |
| correct | **true** |
| must-fix | none |

**Notes.** All six declarations (`def:gr_affine_chart`, `def:gr_transition`, `lem:gr_cocycle`, `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper`) have complete statements, sound proof sketches, `\lean{}` pins, and proper SOURCE citations from Nitsure §1. No `\leanok` markers (consistent with scaffold targets). The `def:gr_affine_chart` QUOT-defs target is correctly blueprinted.

---

### 1.5 Picard\_QuotScheme.tex

| field | value |
|---|---|
| complete | **true** |
| correct | **partial** |
| must-fix | none this iter |

**Notes.**

- **`def:modules_annihilator`** — "project-built primitive; Mathlib does not carry an annihilator for sheaves of modules on a scheme." Statement correct; `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` pinned. Ready for scaffold dispatch. ✓
- **`def:is_locally_free_of_rank`** — "project-built; not supplied by Mathlib." Statement correct; `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` pinned. Ready for scaffold dispatch. ✓
- **`def:sectionGradedRing`** — Graded ring R(X\_s, L\_s) = ⊕\_{m≥0} Γ(X\_s, L\_s^{⊗m}). Statement correct; `\lean{AlgebraicGeometry.sectionGradedRing}` pinned. Ready for scaffold dispatch. ✓
- **Pre-existing partial-correctness** — `thm:grassmannian_representable` proof is stated as `RepresentableBy` but the Lean type is `IsAffineHom` (a strictly weaker form). This gap is documented in the chapter with a `% NOTE:` comment and is unchanged from prior iters. It is **not introduced this iter** and does **not affect the three target definitions** listed above (they have no `\uses{}` dependency on `thm:grassmannian_representable`).

---

### 1.6 Picard\_RelativeSpec.tex

| field | value |
|---|---|
| complete | **true** |
| correct | **partial** |
| must-fix | none |

**Notes.** Pre-existing, documented RepresentableBy gap on `thm:relative_spec_univ` (Lean type is `IsAffineHom`, not the full `RepresentableBy` Yoneda form). Not a target this iter. No new issues.

---

## 2 — Dependency and isolation audit

### 2.1 Broken `\uses{}` (unknown\_uses)

**0 unknown\_uses.** Every label referenced in `\uses{}` resolves to a defined node. ✓

### 2.2 Isolated nodes

**0 isolated nodes.** Every node participates in at least one edge. ✓

### 2.3 Orphan-leaf advisory (two nodes)

`lem:base_change_mate_fstar_reindex` and `lem:base_change_mate_gstar_transpose` have **0 reverse-dependencies** in the DAG. They are used only in the PROOF `\uses{}` (not STATEMENT `\uses{}`) of `lem:base_change_mate_generator_trace_eq`. Since leanblueprint statement-level `\uses{}` drives the dependency graph for navigation and prover-ordering, these two sub-lemmas appear as unreferenced leaves — potentially confusing to a prover reading the blueprint DAG. `lem:base_change_mate_unit_value` is correctly wired (it appears in the STATEMENT `\uses{}` of both `fstar_reindex` and `gstar_transpose`).

**Recommended fix (advisory, not must-fix):** Plan agent should add `lem:base_change_mate_unit_value, lem:base_change_mate_fstar_reindex, lem:base_change_mate_gstar_transpose` to the STATEMENT `\uses{}` of `lem:base_change_mate_generator_trace_eq`.

### 2.4 blueprint-doctor

0 malformed\_refs · 0 broken\_refs · 0 orphan\_chapters. Rendering clean. ✓

---

## 3 — Unmatched `\lean{}` nodes (30 total)

All 30 are expected and benign. Categorized:

**Category A — mathlibok nodes (9):** Mathlib provides the declaration; project Lean files do not (by design). `lem:pullbackSpecIso_mathlib`, `lem:cancelBaseChange_mathlib`, `lem:flat_preserves_equalizer_mathlib`, `lem:fp_free_descent`, `lem:noeth_prime_filtration`, `lem:noether_normalization_fg`, `lem:hilbertPoly_exists_mathlib`, `lem:isProper_mathlib`, `lem:functor_is_representable_mathlib`.

**Category B — new FBC sub-lemmas (3):** Blueprinted this iter; not yet in Lean. `lem:base_change_mate_unit_value`, `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose`.

**Category C — new GF sub-lemmas (3):** Blueprinted this iter; not yet in Lean. `lem:gf_clear_one_denominator`, `lem:gf_generic_rank_ses`, `lem:gf_torsion_reindex`.

**Category D — QUOT-defs and SNAP targets (9):** Scaffold dispatch targets this iter or gated by SNAP. `def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg`, `lem:gradedHilbertSerre_rational`, `thm:hilbertPoly_of_sectionModule`, `def:modules_annihilator`, `def:schematic_support`, `def:has_proper_support`, `def:is_locally_free_of_rank`.

**Category E — GrassmannianCells scaffold targets (6):** Scaffold targets (GR-cells/GR-glue phases). `def:gr_affine_chart`, `def:gr_transition`, `lem:gr_cocycle`, `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper`.

---

## 4 — Citation discipline

### 4.1 New FBC sub-lemmas

`lem:base_change_mate_unit_value`, `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose` carry **no SOURCE citations** and no `\textit{Source:…}` lines. This is appropriate: these are Archon-original plumbing steps deriving standard extension-of-scalars adjunction identities, not sourced from external literature. The `% NOTE:` on `gstar_transpose` explicitly says "stands on its proof sketch with no external reference." ✓

### 4.2 New GF sub-lemmas

All three new GF sub-lemmas satisfy full citation discipline:
- `lem:gf_clear_one_denominator`: `% SOURCE:` with file/line, `% SOURCE QUOTE PROOF:` verbatim, `\textit{Source:…}` in prose. ✓
- `lem:gf_generic_rank_ses`: same. ✓
- `lem:gf_torsion_reindex`: same. ✓

Source is Nitsure §4, lines L1755–1768, with file reference `nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`. ✓

### 4.3 `lem:base_change_mate_regroupEquiv` rewritten proof

The proof block `\uses{lem:cancelBaseChange_mathlib, lem:base_change_regroup_linearEquiv}` is correct. No new SOURCE needed (the lemma statement already has a Stacks citation via `lem:base_change_mate_generator_trace_eq`). ✓

---

## 5 — QUOT-defs scaffold lane re-confirmation

| target | chapter | chapter complete | chapter correct | def correct | gate |
|---|---|---|---|---|---|
| `def:modules_annihilator` | Picard\_QuotScheme | true | partial (pre-existing) | **true** | **PASS** |
| `def:is_locally_free_of_rank` | Picard\_QuotScheme | true | partial (pre-existing) | **true** | **PASS** |
| `def:sectionGradedRing` | Picard\_QuotScheme | true | partial (pre-existing) | **true** | **PASS** |
| `def:gr_affine_chart` | Picard\_GrassmannianCells | true | true | **true** | **PASS** |

The chapter-level `correct: partial` on Picard\_QuotScheme is isolated to `thm:grassmannian_representable` (pre-existing, documented, unchanged this iter). The three target definitions have no `\uses{}` dependency on `thm:grassmannian_representable` and are individually correct. Scaffold dispatch for the four defs is authorized.

**Caveat:** Provers working on `thm:grassmannian_representable` itself should treat its proof as blocked until the RepresentableBy gap is resolved (see STRATEGY.md Open strategic questions).

---

## 6 — Hard gate verdicts

### FBC sub-lemma chain (`Cohomology_FlatBaseChange.tex`)

- chapter complete: true ✓
- chapter correct: true ✓
- must-fix: none ✓
- Dispatched targets: `lem:base_change_mate_unit_value`, `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose`, `lem:base_change_mate_generator_trace_eq`

**VERDICT: PASS — cleared for iter-008 prover dispatch.**

### GF sub-lemma chain (`Picard_FlatteningStratification.tex`)

- chapter complete: true ✓
- chapter correct: true ✓
- must-fix: none ✓
- Dispatched targets: `lem:gf_clear_one_denominator`, `lem:gf_generic_rank_ses`, `lem:gf_torsion_reindex`, `lem:gf_polynomial_core` (updated assembly)

**VERDICT: PASS — cleared for iter-008 prover dispatch.**

### QUOT-defs scaffold

- See §5 above.

**VERDICT: PASS (with pre-existing caveat on `thm:grassmannian_representable`).**

---

## 7 — Unstarted-phase blueprint proposals

Cross-referencing STRATEGY.md `## Phases & estimations` against blueprinted content:

### 7.1 GF-geo — geometric wrapper for `thm:generic_flatness` [blueprint-thin]

**Status in strategy:** NEXT (1–2 iters, ~40–120 LOC).

`thm:generic_flatness` is stated in `Picard_FlatteningStratification.tex` with a `\leanok` marker (sorry in proof), but its proof sketch is minimal — three sentences naming the reduction strategy (restrict to affine open, apply algebraic core, patch). No sub-lemma chain exists for:
- `lem:gf_affine_open_restriction` — restriction of M to a non-empty affine open Spec A ⊆ S; relating Γ(F, W) to a finite module over a finite-type A-algebra (described in STRATEGY.md as "real plumbing")
- `lem:gf_genericFlatness_affine_patch` — patching the freeness witness D(f) over a finite affine cover of X above Spec A
- Re-signing obligations: `thm:generic_flatness` needs `[IsQuasicoherent]`+`[IsFiniteType]` coherence hypotheses on the sheaf (per STRATEGY.md re-sign note)

**Proposal:** Expand `Picard_FlatteningStratification.tex` with a new `\section{Geometric form}` (NOT a new file) containing at minimum these two sub-lemmas before the `thm:generic_flatness` statement. Prover dispatch for the geometric form should wait until this section exists.

### 7.2 FBC-B — H⁰-equalizer globalization [blueprint-thin]

**Status in strategy:** NEXT (3–6 iters, ~150–350 LOC).

`thm:flat_base_change_pushforward` is blueprinted (stated with `\leanok`) but its proof block contains no sub-lemma chain. The STRATEGY.md route describes:
- `lem:base_change_map_affine_local` — derived via naturality (pushforward-commutes-with-restriction + adjunction transpose), NOT asserted
- H⁰-as-equalizer packaging (`∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)`, Čech degree 0/1 only)
- `lem:flat_preserves_equalizer_mathlib` usage (`Module.Flat.{ker,eqLocus}_lTensor_eq`)

None of these are currently blueprinted as named nodes. Until FBC-B is a prover target, this is not blocking. When FBC-B prover dispatch is planned, a blueprint expansion pass should precede it.

**Proposal:** Add a `\section{Globalization: H⁰ as equalizer}` section to `Cohomology_FlatBaseChange.tex` with `lem:base_change_map_affine_local` as a named node before dispatching FBC-B prover work.

### 7.3 GR-quot — tautological quotient [fully unstarted]

**Status in strategy:** BLOCKED sub-phase of QUOT-repr (~100–250 LOC).

No blueprint content. Strategy description: "tautological rank-d quotient π\*V ↠ U + its universal property." The GrassmannianCells chapter covers GR-cells and GR-glue only.

**Proposal:** Add a new section `\section{Tautological quotient bundle (GR-quot)}` to `Picard_GrassmannianCells.tex` when QUOT-repr becomes the active frontier, containing:
- `def:gr_tautological_quotient` — the rank-d tautological quotient on the big cells
- `lem:gr_quotient_universal_property` — universal property on U^I
- `lem:gr_quotient_global` — gluing to a global rank-d quotient on the glued scheme

### 7.4 GR-repr — functor-of-points identification [fully unstarted]

**Status in strategy:** BLOCKED sub-phase of QUOT-repr (~100–250 LOC); also depends on RelativeSpec RepresentableBy strengthening.

No blueprint content. `thm:grassmannian_representable` is blueprinted in QuotScheme.tex as a top-level sorry without a sub-lemma chain for the Yoneda identification.

**Proposal:** New file `Picard_GrassmannianRepr.tex` (separate from GrassmannianCells to keep file sizes manageable) when GR-repr becomes active, containing:
- `lem:gr_hom_to_chart` — morphisms S → Gr factor through exactly one big cell (when S is affine)
- `lem:gr_functor_of_points_bijection` — natural bijection Hom\_S(−, Gr) ≅ Grass(V, d)(−)
- `thm:grassmannian_representable` moved here with full `RepresentableBy` proof chain

---

## 8 — Severity summary

| # | finding | severity | chapter(s) | blocks dispatch? |
|---|---|---|---|---|
| 1 | iter-006 must-fix RESOLVED (eT bridge + R'-linearity) | ✓ resolved | FlatBaseChange | N/A |
| 2 | DAG leaf orphans: `fstar_reindex`, `gstar_transpose` not in statement `\uses{}` of `generator_trace_eq` | ADVISORY | FlatBaseChange | No |
| 3 | `thm:grassmannian_representable` proof weaker than stated (pre-existing) | KNOWN (partial-correct) | QuotScheme | No (isolated to that theorem) |
| 4 | GF-geo proof sub-lemma chain not blueprinted | ADVISORY | FlatteningStratification | No (GF-geo is NEXT, not this iter) |
| 5 | FBC-B proof sub-lemma chain not blueprinted | ADVISORY | FlatBaseChange | No (FBC-B is NEXT, not this iter) |
| 6 | GR-quot and GR-repr have no blueprint content | ADVISORY | (new) | No (BLOCKED phase) |

**No must-fix findings for iter-008.**

---

## 9 — Overall verdict

**PASS.** Iter-008 prover dispatch is authorized for:

1. **FBC sub-lemma chain** — `lem:base_change_mate_unit_value`, `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose`, `lem:base_change_mate_generator_trace_eq`. The iter-006 must-fix is resolved; all three new sub-lemmas are well-formed; the thin assembly is consistent.

2. **GF sub-lemma chain** — `lem:gf_clear_one_denominator`, `lem:gf_generic_rank_ses`, `lem:gf_torsion_reindex`, plus the updated `lem:gf_polynomial_core` assembly. The Lean proof structure note (base-domain generalization) is load-bearing and correct.

3. **QUOT-defs scaffold** — `def:modules_annihilator`, `def:is_locally_free_of_rank`, `def:sectionGradedRing` (from QuotScheme.tex), `def:gr_affine_chart` (from GrassmannianCells.tex). All four are individually correct and independently clearable. The pre-existing `thm:grassmannian_representable` partial-correctness does not propagate to these targets.

**Recommended plan-agent action before closing iter-007:**
- Add `lem:base_change_mate_unit_value, lem:base_change_mate_fstar_reindex, lem:base_change_mate_gstar_transpose` to the STATEMENT `\uses{}` of `lem:base_change_mate_generator_trace_eq` (DAG wire-up advisory, §2.3).
