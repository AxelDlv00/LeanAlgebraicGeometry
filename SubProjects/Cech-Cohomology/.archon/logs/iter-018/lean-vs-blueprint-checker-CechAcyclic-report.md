# Lean ↔ Blueprint Check Report

## Slug
CechAcyclic

## Iteration
018

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAcyclic.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

The chapter's `\lean{...}` block covering CechAcyclic.lean declarations lives entirely in
`lem:cech_acyclic_affine` (blueprint lines 677–696). It lists 21 items; I check each below.

---

### `\lean{AlgebraicGeometry.sectionCech_affine_vanishing}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: **no** — no declaration by this name appears anywhere in the file; the
  only top-level theorem is `CechAcyclic.affine` (old relative-form name). Per directive this is a
  pre-known gap: the prover built the AwayComparison/CechLocalized infrastructure instead.
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **notes**: Blueprint NOTE (lines 673–676) explicitly acknowledges this refactor is pending: "the
  proposed re-signed name is `sectionCech_affine_vanishing`; the old name `CechAcyclic.affine` is
  kept in the `\lean{}` list until the planner refactor lands". Pre-known per directive.

---

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 74)
- **Signature matches**: **partial** — the informal statement of `lem:cech_acyclic_affine` now
  describes the *section* Čech complex (`sectionCech_affine_vanishing` form), but the Lean
  signature is the old *relative-pushforward* form (`CechComplex f (openCover) F`). The blueprint
  NOTE (lines 673–676) documents this drift explicitly; the old form is retained pending refactor.
- **Proof follows sketch**: **no** — body is `:= sorry` (line 109). The L1 categorical→module
  bridge is still missing.
- **notes**: Pre-known and intentional per directive ("line ~74/109 sorry is a superseded
  relative-form decl, intentional"). The proof-body comment (lines 79–109) explains the L1 gap
  accurately; the CombinatorialCech L3 and CechLocalized L2-prep are done. Superseded by
  `sectionCech_affine_vanishing` once the refactor lands.

---

### `\lean{AlgebraicGeometry.CombinatorialCech.combDifferential}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 143, `private def`)
- **Signature matches**: yes — `(Fin n → ι) → M → (Fin (n+1) → ι) → M`, alternating coface sum,
  exactly as described in the blueprint proof body
- **Proof follows sketch**: yes (definitional)
- **notes**: `private`; matches blueprint description of the alternating-coface differential

---

### `\lean{AlgebraicGeometry.CombinatorialCech.combHomotopy}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 149, `private def`)
- **Signature matches**: yes — prepend-`r` homotopy `u(Fin.cons r τ)`, as in blueprint
- **Proof follows sketch**: yes (definitional)
- **notes**: `private`; correct

---

### `\lean{AlgebraicGeometry.CombinatorialCech.combHomotopy_zero}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 152, `@[simp] private lemma`)
- **Signature matches**: yes — `combHomotopy r 0 = 0`
- **Proof follows sketch**: yes (`simp` + `funext`)
- **notes**: helper lemma; axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.cons_comp_succAbove_succ}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 158, `private lemma`)
- **Signature matches**: yes — bookkeeping identity `(Fin.cons r σ) ∘ k.succ.succAbove = Fin.cons r (σ ∘ k.succAbove)`, as described in the blueprint dependent-port prose
- **Proof follows sketch**: yes (funext + Fin cases + simp)
- **notes**: helper lemma; axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.combHomotopy_spec}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 171, `private lemma`)
- **Signature matches**: yes — `d(ht) + h(dt) = t` on `(Fin (n+1) → ι) → M`
- **Proof follows sketch**: yes — `Fin.sum_univ_succ` split at `j=0` then cancellation by
  `cons_comp_succAbove_succ`, matching the blueprint proof sketch
- **notes**: core homotopy identity; axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.combDifferential_eq_of_cocycle}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 188, `private lemma`)
- **Signature matches**: yes — cocycle ⟹ coboundary: if `dt = 0` then `t = d(ht)`
- **Proof follows sketch**: yes (direct from `combHomotopy_spec`)
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.combSign_flip}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 196, `private lemma`)
- **Signature matches**: yes — sign-reversal under the involution `(j,i) ↦ (j.succAbove i, i.predAbove j)`
- **Proof follows sketch**: yes (case split on `castSucc < j` vs. `≤`, exactly as the blueprint describes the `d² = 0` sign argument)
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.combDifferential_comp}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 216, `private lemma`)
- **Signature matches**: yes — `d ∘ d = 0`
- **Proof follows sketch**: yes — `Finset.sum_involution` with the `(j,i) ↦ (j.succAbove i, i.predAbove j)` involution, as described in the blueprint
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.combDifferential_exact}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 247, `private lemma`)
- **Signature matches**: yes — `Function.Exact` of `combDifferential` at consecutive degrees, given distinguished `r : ι`
- **Proof follows sketch**: yes (assembles `combDifferential_comp` and `combDifferential_eq_of_cocycle`)
- **notes**: axiom-clean; matches the "constant-coefficient L3" step

---

### `\lean{AlgebraicGeometry.CombinatorialCech.depTransport}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 301, `private lemma`)
- **Signature matches**: yes — `h ▸ t x = t y` for `h : x = y`
- **Proof follows sketch**: yes (subst + rfl)
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.cons_comp_zero_succAbove}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 307, `private lemma`)
- **Signature matches**: yes — `(Fin.cons r σ) ∘ (0 : Fin (m+1)).succAbove = σ`
- **Proof follows sketch**: yes (funext + simp)
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.depDiff}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 313, `private def`)
- **Signature matches**: yes — dependent alternating Čech differential via `δ` coface maps
- **Proof follows sketch**: yes (definitional)
- **notes**: axiom-clean; correct dependent generalisation

---

### `\lean{AlgebraicGeometry.CombinatorialCech.depHomotopy}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 319, `private def`)
- **Signature matches**: yes — `c m σ (u (Fin.cons r σ))`, prepend homotopy via `c` map
- **Proof follows sketch**: yes (definitional)
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.depHomotopy_spec}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 328, `private lemma`)
- **Signature matches**: yes — `depDiff δ (depHomotopy r c t) σ + depHomotopy r c (depDiff δ t) σ = t σ`, with `hu`/`hsh` hypotheses as described in the blueprint dependent-port prose
- **Proof follows sketch**: yes — `Fin.sum_univ_succ` split, `hu` closes the `k=0` term, `hsh` cancels the remaining terms; matches the blueprint proof sketch exactly
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.depDiff_eq_of_cocycle}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 360, `private lemma`)
- **Signature matches**: yes — dependent cocycle ⟹ coboundary, consuming `hu`/`hsh`
- **Proof follows sketch**: yes
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.comp_succAbove_swap}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 382, `private lemma`)
- **Signature matches**: yes — `(σ ∘ (j.succAbove i).succAbove) ∘ (i.predAbove j).succAbove = (σ ∘ j.succAbove) ∘ i.succAbove`, the d²=0 swap identity
- **Proof follows sketch**: yes (funext + `Fin.succAbove_succAbove_succAbove_predAbove`)
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.depDiff_comp}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 396, `private lemma`)
- **Signature matches**: yes — `depDiff δ (depDiff δ t) = 0` with `hcomm` hypothesis
- **Proof follows sketch**: yes — same involution argument as `combDifferential_comp`, with transport via `comp_succAbove_swap` and `hcomm`
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.CombinatorialCech.depDiff_exact}` — `lem:cech_acyclic_affine`
- **Lean target exists**: yes (line 431, `private lemma`)
- **Signature matches**: yes — `Function.Exact (depDiff δ (m := m+1)) (depDiff δ (m := m+2))` with `hu`/`hsh`/`hcomm`; exactly the dependent-coefficient analogue of `combDifferential_exact`
- **Proof follows sketch**: yes (assembles `depDiff_comp` + `depDiff_eq_of_cocycle`)
- **notes**: axiom-clean; the key "L3 port" output the blueprint proof sketch calls out

---

## Red Flags

### Placeholder / suspect bodies

- **`CechAcyclic.affine` at line 109**: body is `:= sorry`. Blueprint `lem:cech_acyclic_affine`
  lists this name in its `\lean{...}` bundle and claims a substantive theorem (positive-degree
  vanishing of the Čech complex).
  **Status: pre-known intentional per directive.** The directive explicitly notes this is "a
  superseded relative-form decl" retained only until the refactor to `sectionCech_affine_vanishing`
  lands. The sorry reflects a genuine open L1 gap (categorical→module bridge), not a fake or
  trivially-wrong placeholder. The proof-body comments (lines 79–109) accurately document the
  architectural state.

### Excuse-comments

- **`CechAcyclic.lean:83`**: comment `-- * L1 (categorical→module bridge, STILL MISSING)` on the
  sorry proof body of `CechAcyclic.affine`. This is a workflow-accurate progress note, not an
  "excuse for wrong code" comment: it pinpoints which of the three proof steps remains open and
  why. Pre-known intentional per directive.

### Axioms / Classical.choice on substantive claims

None found.

---

## Unreferenced declarations (informational)

The following 22 declarations live in CechAcyclic.lean but are referenced by **no**
`\lean{...}` block in the blueprint chapter. Per directive, these are "known coverage debt" added
this iteration; substantive ones are listed below (trivial helpers omitted).

**Namespace `AwayComparison` (11 declarations, all substantive):**

| Declaration | Nature |
|---|---|
| `AwayComparison.Inverts` | Definition of the invertibility predicate enabling comparison maps |
| `AwayComparison.Inverts.of_dvd` | Divisor of invertible element is invertible |
| `AwayComparison.Inverts.mul` | `Inverts` closed under multiplication |
| `AwayComparison.Inverts.isUnit_powers` | Powers form compatible with `IsLocalizedModule.lift` |
| `AwayComparison.comparison` | Canonical comparison map `M_a → M_b` between away-localisations |
| `AwayComparison.comparison_apply` | `comparison fa fb hb (fa x) = fb x` |
| `AwayComparison.comparison_comp_structure` | `comparison ∘ fa = fb` |
| `AwayComparison.comparison_unique` | Uniqueness of comparison by universal property |
| `AwayComparison.comparison_self` | Identity law |
| `AwayComparison.comparison_comp` | Composition law (functoriality) |
| `AwayComparison.comparison_comp_apply` | Pointwise composition law |

**Namespace `CechLocalized` (11 declarations, all substantive):**

| Declaration | Nature |
|---|---|
| `CechLocalized.sprod` | `s_σ = ∏_k s(σ k)`, the localising element for multi-index σ |
| `CechLocalized.sprod_cons` | `sprod (Fin.cons i σ) = s i * sprod σ` |
| `CechLocalized.sprod_succAbove_dvd` | Coface drops one factor: `s_{σ∘dⱼ} ∣ s_σ` |
| `CechLocalized.cechCoeff` | Localised coefficient `A_σ = M_{s_r · s_σ}` |
| `CechLocalized.cechCoface` | Concrete coface map `δ : A_{σ∘dⱼ} →+ A_σ` |
| `CechLocalized.cechPrepend` | Concrete prepend map `c : A_{cons r σ} →+ A_σ` |
| `CechLocalized.cechCoeff_transport_eq_comparison` | Transport along equal multi-indices = comparison map |
| `CechLocalized.cech_hu` | Unit compatibility `c ∘ δ₀ = transport` |
| `CechLocalized.cech_hsh` | Shift compatibility `c ∘ δ_{k+1} = δ_k ∘ c` |
| `CechLocalized.cech_hcomm` | Coface commutation `δ_j ∘ δ_i = δ_{j.succAbove i} ∘ δ_{i.predAbove j}` |
| `CechLocalized.cechLocalized_exact` | **Key bridge output**: `Function.Exact` of the localised Čech differential |

The `CechLocalized.*` block is the concrete instantiation of the `depDiff_exact` combinatorial
core for away-localisations. `cechLocalized_exact` is particularly substantive: it is the direct
predecessor of the `exact_of_isLocalized_span` node-by-node input once the L1 identification
(sheaf sections = away-localisation modules) is built. These 22 declarations should be added to a
`\lean{...}` bundle — either by extending `lem:cech_acyclic_affine` or by adding a new blueprint
block (e.g. a sub-definition for the localised ℓ¹ algebra).

---

## Blueprint adequacy for this file

- **Coverage**: 19/41 CechAcyclic.lean declarations have a `\lean{...}` pointer (all 19
  `CombinatorialCech.*` covered in `lem:cech_acyclic_affine`). The remaining 22 substantive
  declarations (`AwayComparison.*`, `CechLocalized.*`) are **unpointed** — known coverage debt
  added this iteration per directive.

- **Proof-sketch depth**: **adequate** for the `CombinatorialCech.*` part. The blueprint proof
  sketch of `lem:cech_acyclic_affine` (lines 772–828) describes the three-step reduction (section
  identification via `def:qcoh_sections_localized`, homology-to-exactness via
  `lem:section_cech_homology_exact`, and node-by-node homotopy via `depDiff_exact`) at sufficient
  detail to guide the combinatorial core. The `AwayComparison.*`/`CechLocalized.*` infrastructure
  is described informally in `sec:cech_l1_bridge` (lines 509–664) but without proof-body detail
  in a dedicated block.

- **Hint precision**: **loose** for the AwayComparison/CechLocalized tier. The blueprint mentions
  the `δ`/`c`/`hu`/`hsh`/`hcomm` structure in the proof sketch of `lem:cech_acyclic_affine` (lines
  800–819) and refers to `def:qcoh_sections_localized` as the place where the concrete maps live,
  but `def:qcoh_sections_localized` currently points only to the (unbuilt)
  `qcohSectionsAwayLocalized`. There is no `\lean{...}` hint naming any of the 22 new
  declarations, so a prover would have to discover the correct API names from scratch.

- **Generality**: **matches need** — the AwayComparison/CechLocalized API is at the right level
  of abstraction (abstract `IsLocalizedModule` + concrete `LocalizedModule`) and directly feeds
  `depDiff_exact`.

- **Recommended chapter-side actions**:
  1. Add a `\lean{...}` bundle to `lem:cech_acyclic_affine` (or a new sub-definition) naming the
     22 `AwayComparison.*` and `CechLocalized.*` declarations.
  2. Once `sectionCech_affine_vanishing` is built, update the `\lean{...}` list: remove the old
     `CechAcyclic.affine` entry (or note it deprecated) and replace `sectionCech_affine_vanishing`
     from "not yet present" to present.
  3. Consider promoting `cechLocalized_exact` to a standalone blueprint sub-lemma with a proof
     sketch that names `comparison_comp`/`cech_hu`/`cech_hsh`/`cech_hcomm` explicitly.

---

## Severity summary

| Finding | Severity | Pre-known? |
|---|---|---|
| `sectionCech_affine_vanishing` not present in Lean (blueprint `\lean{}` target missing) | **must-fix-this-iter** | yes — directive explicitly lists it as a known gap |
| `CechAcyclic.affine` body `:= sorry` on a blueprint-claimed substantive theorem | **must-fix-this-iter** | yes — directive calls it "intentional, superseded form"; refactor to section-form pending |
| `CechAcyclic.affine` signature mismatch: file has relative-form (`CechComplex f ...`), blueprint now targets section-form | **major** | yes — blueprint NOTE acknowledges explicitly |
| 22 substantive `AwayComparison.*`/`CechLocalized.*` declarations unreferenced by any `\lean{}` block | **major** | yes — directive: "known coverage debt, report but treat trivial helpers as acceptable" |
| `\lean{CechAcyclic.affine}` excuse-comment (lines 79–109) documenting L1 gap | **minor** | yes — workflow-accurate progress note, not misleading |

**Overall verdict:** The `CombinatorialCech.*` and `AwayComparison`/`CechLocalized` infrastructure
is axiom-clean and mathematically faithful to the blueprint sketch; the two must-fix findings
(`sectionCech_affine_vanishing` absent, `CechAcyclic.affine` sorry) are pre-known intentional
deferrals documented in the directive, and the major coverage debt in `AwayComparison.*`/
`CechLocalized.*` is the expected state after a decomposed-infrastructure prover iteration —
26 declarations checked, 2 must-fix (pre-known), 1 major (pre-known), 22 unreferenced substantive
(known debt).
