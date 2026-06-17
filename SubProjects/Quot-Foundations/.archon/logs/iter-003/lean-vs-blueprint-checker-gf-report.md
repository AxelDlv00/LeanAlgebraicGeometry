# Lean ↔ Blueprint Check Report

## Slug
gf

## Iteration
003

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes
- **Signature matches**: yes — matches the blueprint's explicit `% INTENDED LEAN SIGNATURE` comment verbatim; types, module instances, and scalar-tower hypothesis all align
- **Proof follows sketch**: partial — primary route (M module-finite over A) proved axiom-clean; surviving residue (finite-type B case, the Nitsure §4 dévissage) is `sorry` as expected this iteration
- **notes**: Blueprint `\leanok` is on the statement block only (proof block unmarked); consistent with Lean having a partial proof. LSP confirms sorry warning at line 370.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (chapter: `lem:gf_finite_module`)
- **Lean target exists**: yes
- **Signature matches**: yes — `A` noetherian domain, `M` finite `A`-module, conclusion `∃ f ≠ 0, Module.Free (Loc.Away f) (LocalizedModule (Submonoid.powers f) M)` matches blueprint prose exactly
- **Proof follows sketch**: yes — blueprint says use `Module.FinitePresentation.exists_free_localizedModule_powers` at the generic point; Lean does exactly that (lines 110–114)
- **notes**: Fully proved. `lean_verify` confirms only standard axioms (`propext`, `Classical.choice`, `Quot.sound`). Blueprint `\leanok` on both statement and proof blocks is correct.

---

### `\lean{Module.FinitePresentation.exists_free_localizedModule_powers}` (chapter: `lem:fp_free_descent`)
- **Lean target exists**: N/A — `\mathlibok`, not in this project file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Mathlib anchor, correctly marked `\mathlibok`.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (chapter: `lem:gf_torsion_base`)
- **Lean target exists**: yes
- **Signature matches**: yes — hypothesis `htors : Subsingleton (LocalizedModule (nonZeroDivisors A) M)` is the correct formal encoding of "M_K = 0"; B present as module scaffold; conclusion matches
- **Proof follows sketch**: yes — blueprint says choose annihilators of generators and take product; Lean proof is a faithful formalization of exactly those steps (lines 177–207)
- **notes**: Fully proved axiom-clean (`lean_verify` confirms standard axioms only). The Lean signature omits `[IsNoetherianRing A]` (the proof doesn't use it); this is a valid generalization beyond the blueprint's "noetherian domain A" setup text. The section intro establishes "A noetherian domain" as ambient context, while L1 is more general — minor, not a mismatch.

---

### `\lean{IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime}` (chapter: `lem:noeth_prime_filtration`)
- **Lean target exists**: N/A — `\mathlibok`, not in this project file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Mathlib anchor, correctly marked `\mathlibok`.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (chapter: `lem:gf_splice_shortExact`)
- **Lean target exists**: yes
- **Signature matches**: yes — SES given as explicit `i`, `q` with `hi`, `hq`, `hexact`; `{f' f'' : A}` implicit; freeness hypotheses for each end; conclusion `∃ f ≠ 0, Module.Free (Loc.Away f) (LocalizedModule (Submonoid.powers f) M)` matches
- **Proof follows sketch**: N/A — proof body is `sorry` (expected: L3 scaffolded this iteration); the inline `-- REMAINING` comment accurately enumerates the three sub-steps and is not an excuse-comment
- **notes**: Blueprint `\leanok` on statement block only; LSP confirms sorry at line 220. Pre-known issue.

---

### `\lean{exists_finite_inj_algHom_of_fg}` (chapter: `lem:noether_normalization_fg`)
- **Lean target exists**: N/A — `\mathlibok`, not in this project file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Mathlib anchor, correctly marked `\mathlibok`.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (chapter: `lem:gf_noether_clear_denominators`) — **FLAGGED**

- **Lean target exists**: yes
- **Signature matches**: partial — see detailed analysis below
- **Proof follows sketch**: N/A — proof body is `sorry` (expected: L4 scaffolded this iteration)
- **notes**: Pre-known issue (sorry expected). However, the prover-flagged signature question is assessed in detail here (both directions, as requested).

#### Bidirectional assessment of the L4 `\lean{...}` pin

**Lean → Blueprint (does the Lean signature faithfully realize the prose?)**

The blueprint prose states: "there exist `g ∈ A`, `g ≠ 0`, and elements `b_1, …, b_n ∈ B`, algebraically independent over `K`, such that the localisation `B_g` is module-finite over its polynomial subalgebra `A_g[b_1, …, b_n]`."

The Lean kernel-elaborated type (confirmed via `lean_hover_info`) is:
```
∃ n g, g ≠ 0 ∧
  ∃ x x_1,   -- two anonymous Algebra instance witnesses
    ∃ (_ : IsScalarTower (Loc.Away g) (MvPolynomial (Fin n) (Loc.Away g))
                         (Loc.Away (algebraMap A B g))),
      Function.Injective ⇑(algebraMap (MvPolynomial (Fin n) (Loc.Away g))
                                      (Loc.Away (algebraMap A B g))) ∧
      Module.Finite (MvPolynomial (Fin n) (Loc.Away g)) (Loc.Away (algebraMap A B g))
```

Observations:
1. **"Elements b_j ∈ B" vs. an algebra map.** The blueprint names explicit elements `b_j ∈ B`; the Lean instead existentializes over an `Algebra (MvPolynomial (Fin n) (Loc.Away g)) (Loc.Away (algebraMap A B g))` instance. The `b_j` are implicit as `φ(X_j)` (images of the variables under the algebra map). Mathematically equivalent, but the blueprint doesn't acknowledge this encoding.

2. **B vs. B_g.** The blueprint says `b_j ∈ B`; the Lean's "elements" are in `Loc.Away (algebraMap A B g) = B_g`, i.e., they live after localization. The blueprint proof sketch does say "Each `b̄_j` is `1 ⊗ b_j` for some `b_j ∈ B`" — the prose acknowledges elements can be chosen pre-localization — but the Lean target doesn't expose elements at all, in B or B_g. This is a genuine prose/target gap.

3. **Instance-existentials produce anonymous witnesses.** The kernel renders the two `Algebra` existentials as `x x_1` (no names). A downstream caller doing `obtain ⟨n, g, hg, instAlg1, instAlg2, instTower, hinj, hfin⟩ := ...` gets two `Algebra` instances that must be `letI`-bound before they fire as typeclasses. This is workable but is the "bulkiness" the prover flagged.

4. **Algebraic independence encoding.** `Function.Injective (algebraMap ...)` is the correct formal encoding of algebraic independence of the polynomial generators; the blueprint's "algebraically independent over K" matches this.

Verdict (Lean → Blueprint): **The Lean statement is mathematically correct and faithful to the blueprint's mathematical content.** The encoding choice (algebra instance existentials rather than explicit elements) is not wrong, but the blueprint doesn't document it. A downstream prover reading only the blueprint would not know to use this instance-existential pattern. The `-- REMAINING` comment in the Lean body does explain the intended assembly route clearly.

**Blueprint → Lean (is the chapter adequate to guide formalization of this pin?)**

The chapter has no `% INTENDED LEAN SIGNATURE` block for `lem:gf_noether_clear_denominators` (unlike `thm:generic_flatness`, which has a detailed NOTE explaining its re-signing and giving the exact header). As a result:
- The "elements b_j ∈ B" framing suggests an explicit-elements signature (e.g., `Fin n → B` or `Fin n → B_g`), not an Algebra-instance existential.
- A prover could equally well choose: `∃ (n : ℕ) (g : A) (_ : g ≠ 0) (φ : MvPolynomial (Fin n) (Loc.Away g) →ₐ[Loc.Away g] Loc.Away (algebraMap A B g)), Function.Injective φ ∧ Module.Finite ...` — which would be a genuinely cleaner target (explicit AlgHom, no instance existential; Module.Finite stated over the same algebra structure).
- The blueprint doesn't explain why working in B_g (rather than B) is the right localized target.

**Recommendation (for a blueprint-writing subagent):** Add a `% LEAN SIGNATURE` comment block to `lem:gf_noether_clear_denominators` on the model of the `thm:generic_flatness` NOTE, explaining:
  (a) that the statement works with algebra-map-into-B_g (not explicit elements in B),
  (b) that the instance-existential encoding is intentional, OR
  (c) that the target should be re-stated using an explicit `AlgHom` to avoid anonymous instance witnesses. The blueprint-writing subagent should assess (c) in particular: an explicit AlgHom target (`φ : MvPolynomial (Fin n) (Loc.Away g) →ₐ[Loc.Away g] Loc.Away (algebraMap A B g)`) with `Module.Finite` stated over `φ.toAlgebra` would be cleaner for downstream use in L5 and `genericFlatnessAlgebraic`.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (chapter: `lem:gf_polynomial_core`)
- **Lean target exists**: yes
- **Signature matches**: yes — `d : ℕ`, `Module.Finite (MvPolynomial (Fin d) A) N`, scalar tower `A → MvPolynomial → N`, conclusion `∃ f ≠ 0, Module.Free ...` matches blueprint's "d ≥ 0, N finite over A[X_1,…,X_d], ∃ f ≠ 0 with N_f free over A_f"
- **Proof follows sketch**: partial — base case `d = 0` proved axiom-clean (lines 318–326); inductive step `d ≥ 1` is `sorry` (expected: known issue). The `rcases Nat.eq_zero_or_pos d` case-split matches the blueprint's "induct on d, base d = 0 is lem:gf_finite_module" structure.
- **notes**: Blueprint `\leanok` on statement block only, consistent with inductive step still `sorry`. Pre-known issue.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (chapter: `lem:gf_flat_finite`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Module.Flat` conclusion instead of `Module.Free`; same base hypotheses
- **Proof follows sketch**: yes — blueprint says "by lem:gf_finite_module the module is free; free modules are flat"; Lean proof is exactly that (3 lines, lines 125–127)
- **notes**: Fully proved axiom-clean. Blueprint `\leanok` on both blocks is correct.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (chapter: `lem:gf_free_moduleFinite`) — **FLAGGED**
- **Lean target exists**: yes
- **Signature matches**: partial — see notes
- **Proof follows sketch**: yes — blueprint says reduce to `lem:gf_finite_module` via `Module.Finite` transitivity; Lean does exactly `Module.Finite.trans B M` then delegates
- **notes**: The blueprint prose says "for A a noetherian domain and M a module that is **finite as an A-module**" and calls it "identical to lem:gf_finite_module, packaged against the Module.Finite hypothesis." However, the Lean target's *hypotheses* are: B is a module-finite A-algebra (`[Module.Finite A B]`), M is a finite B-module (`[Module.Finite B M]`); the A-finiteness of M is a *consequence* derived in the proof, not a hypothesis. A reader of the blueprint chapter alone would think this is just lem:gf_finite_module restated, when it is in fact a strictly more general statement (adding the B parameter and reducing to the A-finite case via transitivity). The blueprint section intro says "two file-internal helpers ... package the finite A-module leaf" which compounds the confusion. `lean_verify` confirms fully proved, standard axioms only.

---

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes
- **Signature matches**: yes — blueprint has an explicit `% LEAN SIGNATURE HEADER` comment that matches the Lean declaration at lines 432–439 verbatim, including the coherence encoding as `[F.IsQuasicoherent] [F.IsFiniteType]`, the `letI` module structure, and `Module.Flat Γ(S,U) Γ(F,W)`
- **Proof follows sketch**: N/A — proof body is `sorry` (expected: geometric wrapper deferred until algebraic chain is closed). The `-- Remaining assembly` comment in the Lean gives the 4-step assembly route matching the blueprint's proof sketch (Steps 1–4).
- **notes**: Blueprint `\leanok` on statement block only; consistent with Lean having a `sorry` body. Pre-known issue.

---

## Red flags

### Placeholder / suspect bodies

All `sorry` bodies are in declarations the blueprint marks as statement-`\leanok`-only (not proof-`\leanok`), consistent with the known-issues list:
- `exists_free_localizationAway_of_shortExact` (L3), line 220
- `exists_localizationAway_finite_mvPolynomial` (L4), line 268
- `exists_free_localizationAway_polynomial` (L5 inductive step only), line 307
- `genericFlatnessAlgebraic` (surviving residue), line 370
- `genericFlatness` (geometric wrapper), line 432

None of the `sorry`-bearing declarations are marked proof-`\leanok` in the blueprint. No unexpected sorries.

### Excuse-comments

None found. The `-- REMAINING (...)` comments in sorry bodies are proof-planning notes describing mathematical sub-obligations — they enumerate what remains to be formalized, not excuses for wrong code. None contain "temporary", "placeholder", "wrong but works", or similar red-flag language.

### Axioms / Classical.choice on non-trivial claims

No `axiom` declarations in the file. `lean_verify` on all fully-proved declarations confirms only the standard kernel axioms (`propext`, `Classical.choice`, `Quot.sound`), which are expected for any Mathlib-importing project.

---

## Unreferenced declarations (informational)

**All 9 declarations in the Lean file are referenced by a `\lean{...}` block in the blueprint chapter.** Coverage is complete:

| Declaration | Blueprint reference |
|---|---|
| `exists_free_localizationAway_of_finite` | `lem:gf_finite_module` |
| `exists_flat_localizationAway_of_finite` | `lem:gf_flat_finite` |
| `exists_free_localizationAway_of_moduleFinite` | `lem:gf_free_moduleFinite` |
| `exists_free_localizationAway_of_torsion` | `lem:gf_torsion_base` |
| `exists_free_localizationAway_of_shortExact` | `lem:gf_splice_shortExact` |
| `exists_localizationAway_finite_mvPolynomial` | `lem:gf_noether_clear_denominators` |
| `exists_free_localizationAway_polynomial` | `lem:gf_polynomial_core` |
| `genericFlatnessAlgebraic` | `thm:generic_flatness_algebraic` |
| `genericFlatness` | `thm:generic_flatness` |

---

## Blueprint adequacy for this file

- **Coverage**: 9/9 Lean declarations have a corresponding `\lean{...}` block. 0 unreferenced declarations. 3 Mathlib anchors correctly marked `\mathlibok`.

- **Proof-sketch depth**: **adequate overall / under-specified for L4**. All other blocks have proof sketches sufficient to guide formalization. The L4 block (`lem:gf_noether_clear_denominators`) has adequate mathematical content but no Lean-encoding guidance — it lacks the `% LEAN SIGNATURE` style block that `thm:generic_flatness` carries, which is what prevented a prover from knowing the instance-existential encoding.

- **Hint precision**: **loose for L4, precise elsewhere**. For all declarations except L4, the `\lean{...}` hint names the correct declaration and the prose is specific enough (or has an explicit signature comment) to pin the target. For L4 the hint names the right declaration, but the prose says "elements b_j ∈ B" while the Lean uses an Algebra-instance existential — a prover could legitimately choose a different encoding (e.g., explicit AlgHom) and produce a correct but differently-shaped declaration that requires porting. Additionally, `lem:gf_free_moduleFinite` is described as "M a module that is finite as an A-module" while the actual Lean target has B as an explicit module-finite intermediate — loose enough to mislead.

- **Generality**: **matches need**. No parallel API was introduced to compensate for a too-narrow blueprint definition. The instance-existential encoding in L4 is a formulation choice, not a generality mismatch.

- **Recommended chapter-side actions** (for a blueprint-writing subagent):

  1. **L4 `lem:gf_noether_clear_denominators` — add LEAN SIGNATURE comment block.** On the model of the `thm:generic_flatness` NOTE, add a `% LEAN SIGNATURE` comment before the `\begin{lemma}` that either:
     - (a) Documents the current instance-existential encoding and explains how to destructure it downstream, OR
     - (b) Proposes a cleaner AlgHom-based target: `∃ (n : ℕ) (g : A) (_ : g ≠ 0) (φ : MvPolynomial (Fin n) (Localization.Away g) →ₐ[Localization.Away g] Localization.Away (algebraMap A B g)), Function.Injective φ ∧ letI := φ.toAlgebra; Module.Finite (MvPolynomial (Fin n) (Localization.Away g)) (Localization.Away (algebraMap A B g))`. This would eliminate the anonymous instance witnesses and give downstream provers a named map to work with. The plan agent should make the choice between (a) and (b) and dispatch the blueprint-writing subagent accordingly.

  2. **`lem:gf_free_moduleFinite` — correct the hypothesis description.** The statement currently says "M a module that is finite as an A-module" and "identical to lem:gf_finite_module." The actual Lean target has B as an explicit parameter with `[Module.Finite A B]` and `[Module.Finite B M]`; A-finiteness of M is derived. The prose should be updated to say: "For A a noetherian domain, B a module-finite A-algebra, and M a finite B-module (with the compatible A-module structure via the scalar tower A → B → M), there exists f ≠ 0 such that LocalizedModule (Submonoid.powers f) M is free over Localization.Away f."

---

## Severity summary

| Finding | Severity |
|---|---|
| L4 blueprint prose says "elements b_j ∈ B" but Lean uses Algebra-instance existentials; no LEAN SIGNATURE comment to bridge the gap; prover would have to guess the encoding | **major** |
| `lem:gf_free_moduleFinite` blueprint prose incorrectly describes hypotheses (says "M finite as A-module" omitting the role of B as module-finite intermediate) | **major** |
| L1 (`exists_free_localizationAway_of_torsion`) Lean omits `[IsNoetherianRing A]` (a valid generalization beyond the blueprint's setup text); blueprint intro says "noetherian domain" but the lemma doesn't need it | **minor** |

All `sorry` bodies are pre-known issues (statement-`\leanok`-only in the blueprint), axiom-clean fully-proved declarations use only standard kernel axioms, and no excuse-comments or suspect bodies are present.

**Overall verdict**: The Lean file faithfully implements the mathematical content of the blueprint — all signatures match the intended formal targets, proved declarations are axiom-clean, and the sorry-bearing stubs are honest scaffolding. The two major findings are both blueprint-side adequacy failures (L4 encoding undocumented; `lem:gf_free_moduleFinite` prose misstates hypotheses) that a blueprint-writing subagent should address; they do not block Lean progress.
