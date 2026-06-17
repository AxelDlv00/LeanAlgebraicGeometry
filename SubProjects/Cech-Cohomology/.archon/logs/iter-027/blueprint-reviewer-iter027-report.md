# Blueprint review — iter-027

## Slug
blueprint-reviewer-iter027

## Iteration
027

## Diagnostic tool results

**leandag build --json** (tail):
```
"unknown_uses": []
```
Zero broken `\uses{}` edges. All 01EO chain nodes, naturality node, and P5a/P5b nodes registered and resolved.

**archon blueprint-doctor --json**:
```json
{
  "broken_refs": [],
  "malformed_refs": [],
  "axiom_decls": [],
  "covers_problems": [],
  "orphan_chapters": [],
  "labels_defined_count": 96
}
```
Zero findings across all lint checks. 96 labels.

---

## Per-chapter

### `Cohomology_HigherDirectImage.tex`
**complete: true · correct: true**
Single definition `def:higher_direct_image`, `\lean{AlgebraicGeometry.higherDirectImage}`, `\leanok`. Nothing pending. Clean.

---

### `Cohomology_AcyclicResolution.tex`
**complete: true · correct: true**
Full P4 coverage: `rightDerivedIsoOfAcyclicResolution` and its horseshoe/dimension-shift supporting lemmas all `\leanok`. All Mathlib anchors (`lem:right_derived_injective_resolution`, `lem:right_derived_vanishes_injective`, `lem:right_derived_zero_iso_self`, `lem:homology_long_exact_sequence`, `lem:horseshoe_biprod_injective`, `lem:horseshoe_degree_split`) carry `\mathlibok`. Clean.

---

### `Cohomology_CechHigherDirectImage.tex`
**complete: true · correct: true**

Full coverage of all 7 `% archon:covers` files. Audit findings below.

#### `\leanok` inventory (axiom-clean declarations present in chapter)
All previously confirmed axiom-clean declarations retain `\leanok` and are registered in the DAG: `def:cech_nerve`, `def:cech_complex`, `def:cover_arrow`, `def:push_pull_obj`, `def:relative_cech_complex_of_nerve`, `lem:push_pull_id`, `lem:push_pull_comp`, `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`, `def:push_pull_functor`, `def:cech_nerve_cosimplicial`, `lem:section_cech_module_exact`, `lem:cech_free_complex_quasi_iso`, `lem:section_cech_complex_mapop_iso`, `lem:injective_cech_acyclic`, `lem:ses_cech_h1`, `def:jshriek_ou`, `lem:jshriek_corepr`, `def:absolute_cohomology`, `lem:cech_computes_cohomology`.

#### Project-wrapper blocks (iter-027 focus area 2)

| Label | Lean pin | `\leanok` | Assessment |
|---|---|---|---|
| `lem:absolute_cohomology_zero` | `absoluteCohomologyZeroAddEquiv` | ✓ | Correct. H⁰≅Γ via Ext.homEquiv₀ ∘ jShriekOU_homEquiv chain |
| `lem:absolute_cohomology_zero_natural` | `absoluteCohomologyZeroAddEquiv_naturality` | — | Correctly absent — new scaffold target |
| `lem:absolute_cohomology_injective_vanishing` | `absoluteCohomology_eq_zero_of_injective` | ✓ | Correct. Ext.eq_zero_of_injective on 2nd arg |
| `lem:absolute_cohomology_covariant_les` | `absoluteCohomology_covariant_exact₁/₂/₃` | ✓ | Correct. Ext.covariant_sequence_exact₁/₂/₃ at fixed 1st arg |

**Naturality correctness.** `lem:absolute_cohomology_zero_natural` states the commuting square:
```
  Γ(U, I) ——g_U——> Γ(U, Q)
     ≅|                 |≅
  H⁰(U,I) ——H⁰(g)——> H⁰(U,Q)
```
where both verticals are the H⁰≅Γ equivalence. The proof section explicitly states: "In particular, when g_U is surjective so is H⁰(U,g) — the transfer used by the surjectivity step of Lemma lem:absolute_cohomology_one_vanishing." This is precisely the content consumed: `lem:absolute_cohomology_one_vanishing` applies the covariant Ext LES at `n=1`, obtains `δ: H¹(U,F)→H¹(U,I)`, and must kill it via `H⁰(U,I)→H⁰(U,Q)` surjective. That surjectivity is exactly the naturality transfer of `I(U)↠Q(U)` (from `lem:ses_cech_h1`) across the H⁰≅Γ iso. The connection is correct and precisely scoped.

**`\uses` check for wrappers.** `lem:absolute_cohomology_one_vanishing` carries `\uses{..., lem:absolute_cohomology_zero, lem:absolute_cohomology_zero_natural}` — both iso and naturality cited. DAG edge is live (`unknown_uses: []`). Correct.

#### 01EO decomposition chain (iter-027 focus area 1)

| Label | Lean pin | Mathematical step | `\uses` acyclic? | Induction predicate abstract? |
|---|---|---|---|---|
| `lem:cech_ses_of_basis` | `cechComplex_shortExact_of_basis` | SES `0→Č(I)→Č(F)→Č(Q)→0` from `ses_cech_h1`-surjectivity on basis opens | ✓ | n/a |
| `lem:quotient_vanishing_cech` | `quotient_cech_vanishing_of_basis` | LES from SES: Ȟᵖ(I)=0 by injectivity + Ȟᵖ⁺¹(F)=0 by hyp → Ȟᵖ(Q)=0 | ✓ | ✓ — Q not assumed qcoh |
| `lem:absolute_cohomology_one_vanishing` | `absoluteCohomology_one_eq_zero_of_basis` | Ext LES at n=1; inject vanishing kills H¹(I); naturality surjectivity kills δ | ✓ | n/a |
| `lem:absolute_cohomology_pos_vanishing` | `absoluteCohomology_eq_zero_of_basis` | Induction p≥1 over ALL F with vanishing higher Čech; Q passes the IH via quotient_vanishing | ✓ | ✓ — quantified over all F satisfying Čech-vanishing hypothesis, no qcoh |
| `lem:cech_to_cohomology_on_basis` | `cech_eq_cohomology_of_basis` | Top 01EO: assembles four sub-lemmas under conditions (1)(2)(3) | ✓ | n/a |

**Mathematical faithfulness to Stacks 01EO.** The Stacks proof has three steps: (a) build SES of complexes, (b) use LES + condition (3) inductively on Čech to kill Ȟᵖ(Q), (c) use Ext LES + injective vanishing + H⁰ surjectivity to kill Hᵖ(U,F) by downward induction. The blueprint decomposition maps step (a) → `lem:cech_ses_of_basis`, step (b) → `lem:quotient_vanishing_cech`, and step (c) into two pieces: `lem:absolute_cohomology_one_vanishing` (base case p=1) and `lem:absolute_cohomology_pos_vanishing` (induction p→p+1). The split is mathematically correct and well-motivated (the base case and the induction step have distinct Lean proofs). Coverage is complete.

**Inductive predicate (critical gate question).** `lem:absolute_cohomology_pos_vanishing` quantifies over ALL sheaves `F` satisfying the Čech-vanishing hypothesis — not over quasi-coherent sheaves. The quotient `Q = coker(I(U)→F(U))` is built as a sheaf of modules (injective quotient in `X.Modules`); it is not quasi-coherent in general. The blueprint does not impose quasi-coherence on Q at any step. The abstraction is correct.

**`\uses` edges acyclicity.** The chain is:
```
cech_to_cohomology_on_basis
  → cech_ses_of_basis (→ ses_cech_h1, cech_complex)
  → quotient_vanishing_cech (→ cech_ses_of_basis, injective_cech_acyclic)
  → absolute_cohomology_one_vanishing (→ absolute_cohomology_zero_natural, absolute_cohomology_covariant_les, absolute_cohomology_injective_vanishing)
  → absolute_cohomology_pos_vanishing (→ absolute_cohomology_one_vanishing, quotient_vanishing_cech, ext_covariant_les_mathlib, ext_eq_zero_of_injective_mathlib)
```
leandag confirms `unknown_uses: []`. No cycle; correct DAG.

#### P5a/P5b nodes
`lem:cech_augmented_resolution`, `def:cohomology_sheaf_is_sheafify_homology`, `lem:higher_direct_image_presheaf`, `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic` — all present in chapter with `\lean{}` pins, no `\leanok` (correctly awaiting P5a/P5b formalization). `lem:cech_computes_cohomology` (protected target) has its `\uses` block listing these P5a inputs plus `lem:acyclic_resolution_computes_derived`.

#### Mathlib anchors check
All five Ext `\mathlibok` blocks (`lem:ext_bifunctor_mathlib`, `lem:hasext_standard_mathlib`, `lem:ext_homequiv_zero_mathlib`, `lem:ext_eq_zero_of_injective_mathlib`, `lem:ext_covariant_les_mathlib`) carry correct Lean name pins matching `CategoryTheory.Abelian.Ext` API. Blueprint-doctor reports zero `axiom_decls`. Correct.

---

## Must-fix findings

**NONE.**

---

## Hard gate verdict

**`Cohomology_CechHigherDirectImage.tex`: HARD GATE CLEARS.**

- leandag: `unknown_uses: []` ✓
- blueprint-doctor: zero broken refs, zero malformed refs, zero covers_problems ✓
- 01EO chain: mathematically faithful, `\uses` acyclic, inductive predicate abstract ✓
- Naturality block: correctly identified new scaffold target, correctly consumed by 01EO ✓
- All Lean name pins present and correctly formatted ✓

All 7 covered files are unblocked. Planner may dispatch:
1. **`AbsoluteCohomology.lean` 01EO scaffold** — `lem:cech_ses_of_basis` → `lem:quotient_vanishing_cech` → `lem:absolute_cohomology_one_vanishing` → `lem:absolute_cohomology_pos_vanishing` → `lem:cech_to_cohomology_on_basis`, plus the new `absoluteCohomologyZeroAddEquiv_naturality` declaration.

---

## Formalize-readiness verdict

**01EO sub-lemma chain: FORMALIZE-READY.**

Each of the five lemmas has: a fully-stated theorem (hypotheses explicit, conclusion precise), an adequate informal proof sketch, correct `\uses` links to already-axiom-clean upstream lemmas (`ses_cech_h1`, `injective_cech_acyclic`, `absolute_cohomology_covariant_les`, `absolute_cohomology_injective_vanishing`, `absolute_cohomology_zero`), and a `\lean{}` pin for the target Lean name. The induction is correctly set up to avoid quasi-coherence on Q.

**Naturality obligation: FORMALIZE-READY.**

`lem:absolute_cohomology_zero_natural` (`absoluteCohomologyZeroAddEquiv_naturality`): the commuting-square statement is precise, the mechanism is spelled out (functoriality of the composite iso), the downstream consumption is correctly identified. This is the single new declaration the scaffold must build.

The planner may dispatch a scaffold+build lane for the full 01EO chain (including the naturality declaration) in the next iteration.

---

## Unstarted-phase blueprint proposals

**None required.** All active phases (P3b, P5a, P5b) have blueprint coverage:
- P3b: complete (all bridge bricks done + AbsoluteCohomology wrappers axiom-clean + 01EO chain blueprinted).
- P5a: `lem:cech_augmented_resolution`, `lem:higher_direct_image_presheaf`, `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic` — all present with `\lean{}` pins, awaiting Lean formalization.
- P5b: `lem:cech_computes_cohomology` present (protected, `\leanok` pending assembly). The Route-A proof sketch is complete.

No phase lacks blueprint coverage.

---

## Return value

`complete: true · correct: true` on all three chapters; HARD GATE CLEARS for `Cohomology_CechHigherDirectImage.tex`; 01EO sub-lemma chain + naturality obligation are FORMALIZE-READY; zero must-fix findings; no unstarted-phase proposals needed.
