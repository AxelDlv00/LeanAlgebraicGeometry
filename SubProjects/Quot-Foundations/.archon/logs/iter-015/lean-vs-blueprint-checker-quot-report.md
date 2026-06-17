# Lean ↔ Blueprint Check Report

## Slug
quot

## Iteration
015

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration (this iteration's new/changed declarations)

### `\lean{AlgebraicGeometry.GradedModule.degreewise_finrank_diff}` (chapter: `lem:graded_degreewise_finrank_diff`, D5)

- **Lean target exists**: yes — `GradedModule.degreewise_finrank_diff`, line 670
- **Signature matches**: yes — blueprint states `dim_κ W − dim_κ V = dim_κ(W / range φ) − dim_κ(ker φ)`; Lean states `(Module.finrank κ W : ℤ) - Module.finrank κ V = (Module.finrank κ (W ⧸ LinearMap.range φ) : ℤ) - Module.finrank κ (LinearMap.ker φ)`. The cast to `ℤ` is the correct encoding of signed subtraction. Perfect match.
- **Proof follows sketch**: yes — blueprint's `\uses` lists `lem:finrank_range_add_finrank_ker_mathlib` (`LinearMap.finrank_range_add_finrank_ker`) and `lem:finrank_ses_additive_mathlib` (`Submodule.finrank_quotient_add_finrank`); the Lean proof uses both verbatim and closes with `omega`. Mathematically identical.
- **Notes**: `\leanok` on statement block matches (declaration formalized). Proof is axiom-clean (no sorry). Namespace is `AlgebraicGeometry.GradedModule` (inside `namespace AlgebraicGeometry`, outside `section G1`). **PASS.**

---

### G1(a) — `AlgebraicGeometry.GradedModule.homogeneousSubmodule_inf_iSupIndep` (NEW, no blueprint pin)

- **Lean target exists**: yes — public `theorem homogeneousSubmodule_inf_iSupIndep`, line 633
- **Blueprint `\lean{}` pin**: **none** — no `\lean{...}` entry in the chapter for this declaration.
- **Blueprint G1 pin (broken)**: `lem:graded_homogeneousSubmodule_decomposition` is pinned to `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_decomposition}`, a declaration that does **not exist** in the Lean file. The prover instead landed two component lemmas.
- **Signature vs. blueprint G1 prose**: The blueprint's G1 describes the full internal direct sum decomposition of a homogeneous submodule `p`: independence of the graded pieces (`ℳ i ⊓ p`) AND their supremum equalling `p`. This lemma captures the **independence half**: `iSupIndep fun i => ℳ i ⊓ p`. Mathematically this is the correct piece.
- **Proof faithfulness**: proof is `((DirectSum.Decomposition.isInternal ℳ).submodule_iSupIndep).mono fun _ => inf_le_left` — uses the independence of the ambient decomposition and restricts to the infimum. This is exactly the independence argument the blueprint's G1 proof describes ("injective because the M_n are independent in M"). ✓
- **Notes**: Axiom-clean. This is the substantive independence half of G1. Without a `\lean{}` pin it is invisible to blueprint navigation and the `sync_leanok` tracker.

---

### G1(b) — `AlgebraicGeometry.GradedModule.homogeneousSubmodule_iSup_inf_eq` (NEW, private helper)

- **Lean target exists**: yes — `private theorem homogeneousSubmodule_iSup_inf_eq`, line 649
- **Blueprint `\lean{}` pin**: none (private; acceptable for internal helpers).
- **Signature vs. blueprint G1 prose**: captures the **supremum half**: `⨆ i, (ℳ i ⊓ p) = p` under `p.IsHomogeneous ℳ`. This is the surjectivity piece that the blueprint's G1 proof describes ("This exhibits every element of p as a finite sum of elements of the subspaces p ∩ M_n, so the canonical map is surjective").
- **Proof faithfulness**: uses `DirectSum.sum_support_decompose` to decompose an element, then `Submodule.IsHomogeneous.mem_iff` to conclude each component lies in `p`. Matches the blueprint proof sketch. ✓
- **Notes**: Declared private — not subject to blueprint pinning. Together with G1(a) the two lemmas cover the full G1 content. The `isDefEq` heartbeat blocker that prevented assembly into the full `DirectSum.IsInternal`-form G1 is noted in the Lean docstring.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`) — pre-existing skeleton

- **Lean target exists**: yes — `Grassmannian.representable`, line 225 (body `:= sorry`)
- **Signature matches**: **partial** — blueprint prose asserts representability by a **smooth projective** `S`-scheme of **relative dimension** `d(r−d)`, with a **tautological rank-`d` quotient** and **Plücker embedding** `Gr_S(V,d) ↪ ℙ_S(⋀^d V)`. Lean statement is `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`, omitting smoothness, properness, relative dimension, tautological quotient, and Plücker embedding.
- **Proof follows sketch**: N/A (body is sorry).
- **Notes**: Blueprint has an explicit `% NOTE:` acknowledging the weakening ("currently a weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d), the tautological rank-d quotient, and the Plücker embedding"). `\leanok` on statement block is correct per project convention (sorry present). The weakening is documented and intentional for the skeleton phase.

---

### Selected prior-iter blueprint pins (informational, confirming stability)

| Blueprint label | `\lean{...}` target | Lean status |
|---|---|---|
| `lem:graded_homogeneousSubmodule_decomposition` (G1) | `GradedModule.homogeneousSubmodule_decomposition` | **MISSING** — pin broken; prover landed two sub-lemmas instead |
| `lem:graded_quotient_decomposition` (G2) | `GradedModule.quotient_decomposition` | missing, BLOCKED |
| `lem:graded_quotientRing_gradedRing` (G3) | `GradedModule.quotientRing_gradedRing` | missing, BLOCKED |
| `lem:graded_regrade_over_quotient` (G4) | `GradedModule.regrade_over_quotient` | missing, BLOCKED |
| `lem:graded_finite_transfer` (G5) | `GradedModule.finite_over_quotient` | missing, BLOCKED |
| `lem:gradedHilbertSerre_rational` | `gradedModule_hilbertSeries_rational` | missing, BLOCKED |
| `lem:qcoh_section_localization_basicOpen` | `Scheme.Modules.isLocalizedModule_basicOpen` | missing, BLOCKED |
| `def:hilbert_polynomial` | `Scheme.hilbertPolynomial` | exists, sorry body; `\leanok` ✓ |
| `def:quot_functor` | `Scheme.QuotFunctor` | exists, sorry body; `\leanok` ✓ |
| `def:grassmannian_scheme` | `Scheme.Grassmannian` | exists, sorry body; `\leanok` ✓ |
| `lem:annihilator_localization_eq_map` | `Module.annihilator_isLocalizedModule_eq_map` | exists, proof complete; `\leanok` ✓ |
| `def:modules_annihilator` | `Scheme.Modules.annihilator` | exists, body complete; `\leanok` ✓ |
| All `IsRatHilb` toolkit (9 decls) | `AlgebraicGeometry.IsRatHilb.*` | all exist, proofs complete; `\leanok` ✓ |

---

## Red flags

### Placeholder / suspect bodies

- `Scheme.hilbertPolynomial` (line 123): body `:= sorry`. Blueprint `def:hilbert_polynomial` claims a substantive invariant (Hilbert polynomial of a coherent sheaf). **However:** `\leanok` is on the statement block (project convention: sorry-bodied skeletons during build-up phase are explicitly acceptable at statement-`\leanok` level). The docstring says "iter-177+: the body unfolds to the graded-Euler-characteristic construction once χ of a coherent sheaf...". Not a new issue.
- `Scheme.QuotFunctor` (line 161): body `:= sorry`. Same situation — statement-`\leanok` skeleton. Known.
- `Scheme.Grassmannian` (line 198): body `:= sorry`. Same. Known.
- `Scheme.Grassmannian.representable` (line 225): body `:= sorry`, AND statement is weaker than blueprint prose (see Per-declaration entry above). Blueprint `% NOTE:` acknowledges this explicitly.

None of these are new this iteration; all four were established in iter-176 per the file module doc.

### Broken `\lean{}` pins (no corresponding Lean declaration)

1. `lem:graded_homogeneousSubmodule_decomposition` → `GradedModule.homogeneousSubmodule_decomposition` — **does not exist**. The prover this iter landed `homogeneousSubmodule_inf_iSupIndep` + `homogeneousSubmodule_iSup_inf_eq` instead. The blueprint pin must be updated: either combine the two sub-lemmas into `homogeneousSubmodule_decomposition`, or split the G1 blueprint entry into two entries pinned to the actual declarations.

2. `lem:graded_quotient_decomposition` through `lem:graded_finite_transfer` (G2–G5): all broken for the same reason — declarations don't yet exist (elaborator blocker). Not new this iteration.

---

## Unreferenced declarations (informational)

| Declaration | Lean file location | Notes |
|---|---|---|
| `GradedModule.homogeneousSubmodule_inf_iSupIndep` | line 633 (public theorem) | **substantive** — independence half of G1; no `\lean{}` pin anywhere in chapter; should be blueprint-referenced |
| `GradedModule.homogeneousSubmodule_iSup_inf_eq` | line 649 (private theorem) | helper — supremum half of G1; private, acceptable without pin |

`homogeneousSubmodule_inf_iSupIndep` is the only substantive public declaration in the Lean file that has no `\lean{}` reference in the blueprint chapter. All other public declarations are reachable via `\lean{...}` pins.

---

## Blueprint adequacy for this file

### Coverage

- **Lean declarations with a `\lean{}` blueprint pin**: ~19 non-Mathlib declarations (all `IsRatHilb` toolkit, `degreewise_finrank_diff`, all four main skeletons, `annihilator`, `schematicSupport`, `schematicSupportι`, `HasProperSupport`, `IsLocallyFreeOfRank`, `annihilator_ideal_le`, `annihilator_isLocalizedModule_eq_map`).
- **Lean declarations without a `\lean{}` pin**: 2 (`homogeneousSubmodule_inf_iSupIndep` — substantive, flag; `homogeneousSubmodule_iSup_inf_eq` — private helper, acceptable).
- **Blueprint `\lean{}` pins with no corresponding Lean declaration**: 11 (5 Stacks-section sub-build: `sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`, `gradedModule_hilbertSeries_rational`, `hilbertPolynomialOfSectionModule`; 5 G1–G5 elaborator-blocked: `homogeneousSubmodule_decomposition`, `quotient_decomposition`, `quotientRing_gradedRing`, `regrade_over_quotient`, `finite_over_quotient`; 1 bridge: `isLocalizedModule_basicOpen`).

**Net**: 19/21 substantive Lean declarations blueprint-referenced; 1 substantive missing.

### Proof-sketch depth: **adequate for D5 and G1**

- **D5**: The blueprint's proof sketch at `lem:graded_degreewise_finrank_diff` is precise (two Mathlib lemmas cited, algebra spelled out, `omega`-closable). It fully guided the Lean proof.
- **G1**: The blueprint's `lem:graded_homogeneousSubmodule_decomposition` proof sketch (lines 888–904) describes both the independence and supremum arguments in enough detail to guide both sub-lemmas the prover landed. The sketch is mathematically complete; the gap is pin-level, not content-level.
- **G2–G5, Hilbert-Serre, QCoh bridge**: All lack Lean implementations (BLOCKED). Their blueprint sketches are detailed but have not been tested against formalization yet.

### Hint precision: **wrong for G1, precise for D5**

- **D5**: `\lean{AlgebraicGeometry.GradedModule.degreewise_finrank_diff}` — correct, resolves to the existing declaration. **Precise.**
- **G1**: `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_decomposition}` — **wrong**. No such declaration exists. The prover's two sub-lemmas use different names. The pin fails to resolve.
- **G1(a)**: No `\lean{}` pin at all — a public theorem with no blueprint reference.

### Generality: **matches need**

The G1(a) and G1(b) lemmas are stated for any `DirectSum.Decomposition ℳ` over any semiring `R` (not just a graded `κ`-algebra). This is strictly more general than the blueprint's setting (`R` with degree-zero field `κ`). No gap — the Lean API is usable in the Hilbert-Serre induction.

### Recommended chapter-side actions

1. **Fix G1 pin** (must happen before `sync_leanok` can mark G1 as formalized): replace `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_decomposition}` in `lem:graded_homogeneousSubmodule_decomposition` with either:
   - Two entries: add a new `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_inf_iSupIndep}` for the public G1(a) result and note G1(b) as a private helper; or
   - One combined declaration `homogeneousSubmodule_decomposition` that packages both (the prover should create this once the `isDefEq` elaborator blocker is addressed and the full `DirectSum.IsInternal`-form G1 becomes feasible).
   
   Recommended: split into a public G1(a) entry (independence) + a note that G1(b) is a file-private helper, and retitle G1 as "G1 (independence half)". Mark `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_inf_iSupIndep}`.

2. **Add a blueprint entry for `homogeneousSubmodule_inf_iSupIndep`** — it is a substantive public lemma. It should appear under `\subsubsection*{Induced gradings on the derived objects}` as a new `lem:graded_homogeneousSubmodule_inf_iSupIndep` block with the `\lean{}` pin.

3. **Note the G1 split** in `lem:graded_homogeneousSubmodule_decomposition`'s proof or preamble: explain that in Lean the full G1 is assembled from two separately proved halves (independence and supremum-equality) because the `DirectSum.IsInternal`-subtype form triggers an `isDefEq` elaborator heartbeat. The docstring in the Lean file already carries this note; the blueprint should mirror it with a `% NOTE:` comment.

4. **Note on `Grassmannian.representable` weakening**: the existing `% NOTE:` in the blueprint is adequate. No new action needed this iteration — the full statement is the iter-177+ target.

---

## Severity summary

| Finding | Severity | File |
|---|---|---|
| G1 blueprint pin `homogeneousSubmodule_decomposition` broken (no such Lean declaration) | **major** | blueprint |
| Public Lean declaration `homogeneousSubmodule_inf_iSupIndep` has no `\lean{}` pin | **major** | blueprint |
| `Grassmannian.representable` Lean statement weaker than blueprint prose (known, documented) | **major** | both (documented via `% NOTE:`) |
| G2–G5 blueprint pins broken (declarations missing, BLOCKED by elaborator) | **major** | blueprint (ongoing from prior iters) |
| Private declarations in `IsRatHilb` toolkit named in `\lean{}` pins (private names don't resolve cross-file) | **minor** | blueprint |
| D5 (`degreewise_finrank_diff`): declaration exists, signature exact, proof complete, pin correct | — | PASS |

**Overall verdict**: The three new axiom-clean declarations land correctly — D5 is statement-faithful and proof-faithful to its blueprint entry; the two G1 sub-lemmas are mathematically faithful to the G1 blueprint content — but the blueprint's G1 `\lean{}` pin is broken (names a non-existent declaration), and the public independence lemma `homogeneousSubmodule_inf_iSupIndep` has no blueprint reference. Blueprint surgery on G1 is the required follow-up action; no Lean corrections needed.

---

`quot: 3 new axiom-clean declarations verified (D5 pass; G1 two sub-lemmas correct but blueprint pin broken) — ~21 declarations checked, 2 red flags (broken G1 pin, missing reference for homogeneousSubmodule_inf_iSupIndep)`
