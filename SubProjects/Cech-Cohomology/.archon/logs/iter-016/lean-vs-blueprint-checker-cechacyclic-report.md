# Lean ↔ Blueprint Check Report

## Slug
cechacyclic

## Iteration
016

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAcyclic.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (block `lem:cech_acyclic_affine`)

---

## Per-declaration

The `\lean{...}` bundle for `lem:cech_acyclic_affine` (blueprint lines 511–520) names 10 declarations.
All 10 were located in the Lean file. LSP verification confirmed that `private` declarations
resolve correctly under their unmangled qualified names (e.g. hover at line 143 col 13 returns
`AlgebraicGeometry.CombinatorialCech.combDifferential.{u_1,u_2} ...` — no hash decoration).

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 74)
- **Signature matches**: yes
  - Blueprint: `(R : CommRingCat, F : QCoh(Spec R), s : ι → R, hs : span = ⊤, p ≥ 1) ⊢ Ȟᵖ(𝒰, F) = 0`
  - Lean: `{R : CommRingCat.{u}} {S : Scheme.{u}} (f : Spec R ⟶ S) [IsAffineHom f] {ι : Type u} [Finite ι] (s : ι → R) (hs : ...) (F : (Spec R).Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) : IsZero ((CechComplex f (...) F).homology p)`
  - Match is faithful: `IsZero (... .homology p)` captures `Ȟᵖ = 0`; `hF : F.IsQuasicoherent` is the QC hypothesis; `f : Spec R ⟶ S` with `[IsAffineHom f]` is the affine morphism setup. Minor note: the blueprint's prose says "affine scheme U = Spec A" but the Lean correctly generalises to a morphism `f : Spec R → S` (necessary for the relative Čech complex construction).
- **Proof follows sketch**: N/A — body is `:= sorry`
- **Axioms**: `sorryAx` present (expected).
- **Notes**: Known intentional sorry (L1 categorical→module bridge missing). The scope comment (lines 79–109) is detailed and honest: it identifies exactly what's proved (L2 and L3 available), what's missing (L1 sheaf-section identification of `CechComplex` terms with away-localisation modules and of `IsZero (homology p)` with `Function.Exact`), and what infrastructure is needed. No excuse-language; the sorry is correctly framed as a gap in the current proof state, not as a temporary workaround for a wrong approach.

### `\lean{AlgebraicGeometry.CombinatorialCech.combDifferential}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 143, `private def`)
- **Signature matches**: yes — `(t : (Fin n → ι) → M) : (Fin (n+1) → ι) → M`, body `Σⱼ (-1)ʲ • t (σ ∘ j.succAbove)`, exactly the alternating coface differential described in the blueprint.
- **Proof follows sketch**: N/A (definition)
- **Notes**: `private`, resolves correctly under qualified name per LSP.

### `\lean{AlgebraicGeometry.CombinatorialCech.combHomotopy}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 149, `private def`)
- **Signature matches**: yes — `(r : ι) (u : (Fin (n+1) → ι) → M) : (Fin n → ι) → M`, body `fun τ => u (Fin.cons r τ)`. Matches blueprint's `h(t)_{i₀…i_p} = t_{r i₀…i_p}`.
- **Proof follows sketch**: N/A (definition)
- **Notes**: clean.

### `\lean{AlgebraicGeometry.CombinatorialCech.combHomotopy_zero}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 152, `@[simp] private lemma`)
- **Signature matches**: yes — `combHomotopy r 0 = 0`; trivial bookkeeping simp lemma.
- **Proof follows sketch**: yes (single `simp [combHomotopy]`)
- **Notes**: clean.

### `\lean{AlgebraicGeometry.CombinatorialCech.cons_comp_succAbove_succ}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 158, `private lemma`)
- **Signature matches**: yes — `(Fin.cons r σ) ∘ (k.succ).succAbove = Fin.cons r (σ ∘ k.succAbove)`. This is the bookkeeping identity that underpins the homotopy calculation; it appears in the blueprint proof comment block.
- **Proof follows sketch**: yes (funext + Fin.cases + simp)
- **Notes**: clean.

### `\lean{AlgebraicGeometry.CombinatorialCech.combHomotopy_spec}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 171, `private lemma`)
- **Signature matches**: yes — `combDifferential (combHomotopy r t) + combHomotopy r (combDifferential t) = t`. This is the `dh + hd = id` identity the blueprint describes.
- **Proof follows sketch**: yes — the proof implements the alternating-sum cancellation the blueprint describes: the `j = 0` term collapses by `h0`; the remaining terms cancel in pairs via `cons_comp_succAbove_succ` and sign flip. Mathematical steps match.
- **Notes**: axiom-clean (no `sorryAx` in transitive closure).

### `\lean{AlgebraicGeometry.CombinatorialCech.combDifferential_eq_of_cocycle}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 188, `private lemma`)
- **Signature matches**: yes — `(ht : combDifferential t = 0) : combDifferential (combHomotopy r t) = t`. The `ker ⊆ im` half the blueprint calls "the homotopy half carrying the geometric input."
- **Proof follows sketch**: yes (follows directly from `combHomotopy_spec` by substituting `ht`)
- **Notes**: clean.

### `\lean{AlgebraicGeometry.CombinatorialCech.combSign_flip}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 196, `private lemma`)
- **Signature matches**: yes — the sign-flip identity `(-1)ʲ · (-1)ⁱ = - ((-1)^{j.succAbove i} · (-1)^{i.predAbove j})` used in `d² = 0`. Matches blueprint description "sign-cancellation behind `d² = 0`."
- **Proof follows sketch**: yes (case split on `i.castSucc < j` vs. `i.castSucc ≥ j`, ring arithmetic)
- **Notes**: clean.

### `\lean{AlgebraicGeometry.CombinatorialCech.combDifferential_comp}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 216, `private lemma`)
- **Signature matches**: yes — `combDifferential (combDifferential t) = 0`. The `d² = 0` statement.
- **Proof follows sketch**: yes — the proof uses `Finset.sum_involution` with the permutation `(j, i) ↦ (j.succAbove i, i.predAbove j)` described in the blueprint. Mathematical content matches.
- **Notes**: axiom-clean.

### `\lean{AlgebraicGeometry.CombinatorialCech.combDifferential_exact}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 247, `private lemma`)
- **Signature matches**: yes — `Function.Exact (combDifferential : ((Fin (n+1) → ι) → M) → ...) (combDifferential : ...)`. Blueprint describes this as the `Function.Exact` form that `exact_of_isLocalized_span` consumes.
- **Proof follows sketch**: yes — combines `combDifferential_eq_of_cocycle` (ker ⊆ im) and `combDifferential_comp` (im ⊆ ker). Matches blueprint.
- **Axioms**: `{propext, Classical.choice, Quot.sound}` — **axiom-clean** (no `sorryAx`). ✓

---

## Red flags

### Placeholder / suspect bodies

- `CechAcyclic.affine` (line 109): body is `:= sorry`. Blueprint `lem:cech_acyclic_affine` has a complete `\begin{proof}...\end{proof}` block and claims a substantive result. This is a **must-fix-this-iter** finding per checker rules.

  **Qualifier (directive pre-acknowledged):** The directive explicitly flags this as a known intentional sorry (L1 categorical→module bridge, not yet constructed). The scope comment at lines 79–109 of the Lean file is accurate and honest: it identifies L3 (combinatorial homotopy, both constant and dependent-coefficient forms) as now proved axiom-clean, L2 as supplied by Mathlib, and L1 as the sole remaining gap, with a precise description of what infrastructure is needed (sections of `pushPullObj F` over basic opens as localised modules; abstract cosimplicial differential = alternating localisation coboundary; construction of `δ`/`c` maps from `IsLocalizedModule.Away`). The sorry is not a placeholder for wrong mathematics; it is an accurately-scoped gap in the proof chain.

  **Classification**: must-fix-this-iter (per rules — sorry on a blueprint-claimed substantive lemma), but a known/tracked pin requiring no immediate escalation beyond what the plan agent already knows.

### Excuse-comments
None found. The scope comment on `CechAcyclic.affine` (lines 79–109) is explanatory, not excusing wrong code.

### Axioms / `Classical.choice` on non-trivial claims
None. The only `sorryAx` is the expected one in `CechAcyclic.affine`. All other declarations in the file carry only `{propext, Classical.choice, Quot.sound}` — the standard Lean/Mathlib axiom set. No unauthorized `axiom` declarations.

---

## Unreferenced declarations (informational)

The `CombinatorialCech.Dependent` section (lines 289–458) introduces 9 private helpers that do not appear in the `\lean{...}` bundle of `lem:cech_acyclic_affine`:

| Declaration | Line | Role |
|---|---|---|
| `depTransport` | 301 | Helper: transport of dependent cochain values |
| `cons_comp_zero_succAbove` | 307 | Helper: deleting prepended index recovers σ |
| `depDiff` | 313 | Dependent alternating Čech differential |
| `depHomotopy` | 319 | Dependent contracting homotopy |
| `depHomotopy_spec` | 328 | Dependent `dh + hd = id` identity |
| `depDiff_eq_of_cocycle` | 360 | Dependent `ker ⊆ im` half |
| `comp_succAbove_swap` | 382 | Helper: composite coface symmetry |
| `depDiff_comp` | 396 | Dependent `d² = 0` |
| `depDiff_exact` | 431 | Dependent positive-degree exactness (main consumer) |

All 9 are axiom-clean (verified: `depDiff_exact` carries `{propext, Classical.choice, Quot.sound}`, no `sorryAx`).

These are **substantive declarations** (not mere boilerplate): `depDiff_exact` is the central lemma that L2 (`exact_of_isLocalized_span`) consumes node-by-node, and the whole `Dependent` section is a non-trivial generalisation of the constant-coefficient argument. Their absence from the `\lean{...}` bundle means `sync_leanok` will not track their proof status and the blueprint provides no coverage for a prover resuming work on the L1 bridge.

The directive pre-acknowledges this as "coverage debt already tracked." Classification: **major** (substantive declarations missing from blueprint reference, not mere internal helpers).

---

## Blueprint adequacy for this file

- **Coverage**: 10/10 `\lean{...}`-referenced declarations present and proved (except `CechAcyclic.affine` which is sorry'd for documented reasons). Additionally, 9 substantive private helpers in `CombinatorialCech.Dependent` are unreferenced. Coverage ratio for what's referenced: 10/10 = 100%; for the full file's mathematical content: 10/19 = ~53%.

- **Proof-sketch depth**: **adequate** for the constant-coefficient core (L3 proof route described in blueprint `\begin{proof}` block: L1 categorical bridge, L2 `exact_of_isLocalized_span`, L3 contracting homotopy). The sketch correctly identifies the three-step structure and names the key Lean steps at the right level of abstraction. **Under-specified** for the Dependent section: the blueprint's `\begin{proof}` has no mention of the dependent-coefficient port (`depDiff`/`depHomotopy`, the `hu`/`hsh`/`hcomm` hypotheses, or the `depDiff_exact` theorem). A prover resuming L1 bridge work will need to understand `depDiff_exact`'s interface without blueprint guidance.

- **Hint precision**: **precise** for the 10 referenced declarations. The `\lean{...}` bundle names match the actual Lean identifiers (LSP-confirmed). All private declarations resolve correctly under their unmangled qualified names (Lean 4 does not hash-mangle names referenced via LSP hover within the same file; `sync_leanok` should be able to resolve them if it uses LSP lookup rather than import-side name resolution — flag for the CI team if `sync_leanok` uses a different resolution path).

- **Generality**: **matches need** for the referenced declarations. The `combDifferential`/`combDifferential_exact` API is at the right generality for the constant-coefficient case. The `depDiff_exact` API — which is the actual shape L2 consumes — is not referenced in the blueprint, which is the core coverage gap.

- **Recommended chapter-side actions**:
  1. **Add a `\lean{...}` sub-bundle** (or a sub-lemma block) covering the `Dependent` section: at minimum `depDiff`, `depHomotopy`, `depDiff_exact`, and the three hypothesis types `hu`/`hsh`/`hcomm`. This is the declaration that the L1 bridge will feed, so a prover needs its interface documented.
  2. **Expand the proof sketch** of `lem:cech_acyclic_affine` with a paragraph on the dependent-coefficient port: explain that the localised complex has varying coefficients `M_{s_σ}`, that the away-localisation maps play the role of `δ`, the prepend isomorphisms the role of `c`, and that `depDiff_exact` supplies the `Function.Exact` node consumed by `exact_of_isLocalized_span`. This paragraph should also name the three concrete compatibility hypotheses `hu`/`hsh`/`hcomm` that the L1 bridge must discharge.
  3. **No change needed** to the 10 currently-referenced declarations or to the `CechAcyclic.affine` signature block — both are correct.

---

## Severity summary

| Finding | Severity | Notes |
|---|---|---|
| `CechAcyclic.affine` body is `:= sorry` | **must-fix-this-iter** | Known pin (L1 bridge); directive pre-acknowledged; scope comment honest |
| 9 `CombinatorialCech.Dependent.*` declarations unreferenced by `\lean{...}` | **major** | Directive pre-acknowledges coverage debt; prover resuming L1 will need these |
| `combDifferential_exact`, `depDiff_exact`, all helpers: axiom-clean | OK | No surprises |
| Private declaration name resolution via LSP: correct | OK | No mangling; `sync_leanok` should resolve correctly |

**Overall verdict**: The file faithfully implements the blueprint's mathematical content for the constant-coefficient combinatorial core and adds a sound, axiom-clean dependent-coefficient port; the sole must-fix finding is the known-pinned sorry on `CechAcyclic.affine` (L1 categorical bridge not yet constructed), and the major coverage debt is the 9 `Dependent.*` helpers absent from the `\lean{...}` bundle, which a blueprint-writing subagent should address before the L1 bridge work begins.
