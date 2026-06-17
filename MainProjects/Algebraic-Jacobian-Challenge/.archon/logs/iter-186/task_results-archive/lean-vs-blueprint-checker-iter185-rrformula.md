# Lean ↔ Blueprint Check Report

## Slug
iter185-rrformula

## Iteration
185

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/RRFormula.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_RRFormula.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic}` (chapter: `def:eulerChar_curve`)
- **Lean target exists**: yes (L125, `noncomputable def Scheme.eulerCharacteristic`)
- **Signature matches**: yes — returns `ℤ`, takes `F : Sheaf … (ModuleCat.{u} kbar)`, computes `(finrank kbar (HModule kbar F 0) : ℤ) - (finrank kbar (HModule kbar F 1) : ℤ)`. Blueprint specifies `χ(F) = dim H⁰ − dim H¹` for a `ModuleCat k̄`-flavoured carrier; Lean matches exactly.
- **Proof follows sketch**: N/A (definition body, no proof sketch in chapter)
- **notes**: Blueprint `\leanok` on statement block is correct — body is a concrete subtraction with no sorry. LSP hover confirms no diagnostics.

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l}` (chapter: `def:l_invariant`)
- **Lean target exists**: yes (L175, `noncomputable def l` in namespace `Scheme.WeilDivisor`)
- **Signature matches**: yes — `(D : C.left.WeilDivisor) : ℕ` returning `Module.finrank kbar (Scheme.HModule kbar (sheafOf D) 0)`. Blueprint pins `ℓ(D) := dim_{k̄} H⁰(C, 𝒪_C(D)) ∈ ℕ` via the same `HModule` pipeline.
- **Proof follows sketch**: N/A (definition body)
- **notes**: Blueprint `\leanok` on statement block is correct. The `sheafOf` placeholder from `OcOfD.lean` is consumed here as intended.

---

### `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus}` (chapter: `thm:euler_char_eq_deg_plus_one_minus_genus`)
- **Lean target exists**: yes (L505)
- **Signature matches**: yes — conclusion `eulerCharacteristic C D.sheafOf = D.degree + 1 - ↑(genus C)` (confirmed by LSP hover). No extra hypotheses beyond the standing curve typeclass package; matches the blueprint's "for every `D ∈ Div(C)`" statement for general `g`.
- **Proof follows sketch**: yes — blueprint proof describes induction on free-abelian-group structure of `Div(C)` with base case `D = 0` (using `dim H⁰(C, 𝒪_C) = 1` and genus definition) and inductive step (SES + skyscraper additivity). Lean proof at L516 uses `Finsupp.induction` with exactly these two cases, delegating to `eulerCharacteristic_sheafOf_zero` (base) and `eulerCharacteristic_sheafOf_single_add` (step). Mathematical content is faithful.
- **notes**: Proof body has no direct sorry (confirmed: LSP diagnostics show 0 warnings on this declaration). Blueprint `\leanok` on both statement and proof blocks. The proof transitively depends on `eulerCharacteristic_of_shortExact_skyscraper` (L329) which carries the one remaining sorry — see **Red flags §2** for the `\leanok`-on-proof-block consistency question.

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero}` (chapter: `thm:riemannRoch_genus_zero`)
- **Lean target exists**: yes (L555)
- **Signature matches**: yes — LSP hover confirms `(D : C.left.WeilDivisor) (_hg : genus C = 0) (_hdeg : 0 ≤ D.degree) (_hH1 : Module.finrank kbar (HModule kbar D.sheafOf 1) = 0) : ↑D.l = D.degree + 1`. Blueprint explicitly states the `H¹`-vanishing is threaded as a named premise pending RR.3; this is exactly what the Lean signature does.
- **Proof follows sketch**: yes — proof specialises `eulerCharacteristic_eq_degree_plus_one_minus_genus` to `g = 0`, unfolds χ via `simp`, absorbs `_hH1`. Blueprint's proof description matches exactly (L565–569).
- **notes**: No direct sorry. Blueprint `\leanok` on both statement and proof blocks. Same transitive-sorry concern as above (via the helper chain).

---

## Red flags

### Placeholder / suspect bodies

- **`Scheme.eulerCharacteristic_of_shortExact_skyscraper`** at L329: body is `:= by sorry`. This is the file's sole remaining sorry, confirmed by the LSP diagnostic (`"declaration uses 'sorry'"` at line 329, column 17). The declaration is a substantive mathematical claim — χ-additivity on a short exact sequence `0 → F → G → H → 0` when `H ≅ skyscraperSheaf P.point kbar`, encoding three Hartshorne IV.1.3 inputs (LES additivity, iso-invariance of χ, χ(k(P)) = 1). **The blueprint's "Lean reference note" at the end of the `thm:euler_char_eq_deg_plus_one_minus_genus` proof block explicitly describes these three inputs but carries no `\lean{...}` pin for this helper.** Classified as **major** (not must-fix-this-iter because the blueprint does not *claim* this declaration is closed — it's an unblueprinted private helper — but its absence from the blueprint prevents the plan agent from scheduling its closure explicitly).

### `\leanok` marker consistency concern

- **`thm:euler_char_eq_deg_plus_one_minus_genus` proof block** and **`thm:riemannRoch_genus_zero` proof block** both carry `\leanok` in the blueprint chapter. Per CLAUDE.md, `\leanok` on a proof block means "proof closed, no sorry." Both proofs transitively depend on `eulerCharacteristic_of_shortExact_skyscraper` (L329, sorry). The chain is: main theorem → `eulerCharacteristic_sheafOf_single_add` → `eulerCharacteristic_sheafOf_succ` → `eulerCharacteristic_of_shortExact_skyscraper` (sorry). Classified as **major** — either `sync_leanok` is only scanning the direct proof body for sorries (not following the call chain through private helpers), or the markers were placed before the current factoring was introduced. The plan agent should verify `sync_leanok`'s transitive-sorry detection behaviour and potentially remove `\leanok` from these two proof blocks until the sorry closes.

### Stale excuse-style comments

- **`RRFormula.lean` file header (L35–44)**: Section `## Status (iter-174 Lane F file-skeleton)` describes the file as an iter-174 skeleton with pins that "carry `sorry` bodies whose closure is iter-175+ work." This is outdated (we are at iter-185, two helpers are closed, one sorry remains). The comment is informational noise rather than an active excuse-comment, so classified as **minor**.

- **`Scheme.finrank_H0_toModuleKSheaf_eq_one` docstring (L228–230)**: States "**iter-183 Lane H status** — Tier-3 honest typed sorry. Body iter-184+ via the `Cohomology_StructureSheafModuleK` H⁰-bridge." But iter-185 closed this declaration axiom-clean — LSP diagnostics confirm zero sorry warnings for it. The stale status comment is misleading (it implies the body is still a sorry when it is not). Classified as **minor** (no wrong code, just stale documentation).

---

## Unreferenced declarations (informational)

Five private declarations in the file have no `\lean{...}` pin in the chapter:

| Declaration | Line | Sorry? | Comment |
|---|---|---|---|
| `Scheme.finrank_H0_toModuleKSheaf_eq_one` | L231 | No (iter-185 closed) | H⁰-bridge helper. Acceptable as private. |
| `Scheme.eulerCharacteristic_of_shortExact_skyscraper` | L329 | **Yes** | Substantive χ-SES claim; see Red flags §1. Blueprint prose covers this step but no `\lean{...}` block. Should be promoted to a chapter block. |
| `Scheme.eulerCharacteristic_sheafOf_succ` | L346 | No (transitive) | Internal stepping stone. Acceptable as private. |
| `Scheme.eulerCharacteristic_sheafOf_zero` | L383 | No | Base-case helper. Acceptable as private. |
| `Scheme.eulerCharacteristic_sheafOf_single_add` | L422 | No (transitive) | Induction helper. Acceptable as private, but its sorry-free status depends on `_succ` closing. |

The only declaration that arguably *should* be promoted to a chapter block is `eulerCharacteristic_of_shortExact_skyscraper` — it is the direct blocker for closing both main theorems and encodes a substantive three-part argument that the blueprint prose already describes (but does not pin).

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 Lean declarations have a corresponding `\lean{...}` block in the chapter. 5 unreferenced private helpers: 4 acceptable internal helpers + 1 substantive (flagged above).
- **Proof-sketch depth**: **adequate** for the four pinned declarations. The `thm:euler_char_eq_deg_plus_one_minus_genus` proof block is exceptionally detailed — it quotes Hartshorne verbatim, names the base case and inductive step explicitly, and even includes a "Lean reference note" that previews the project-side additivity plan. The `thm:riemannRoch_genus_zero` proof block correctly explains the H¹-vanishing as a named premise and its eventual discharge pathway. The proof of `thm:euler_char_eq_deg_plus_one_minus_genus` mentions χ-additivity on SES in the Lean reference note but does not give it a `\lean{...}` block — making it under-specified for the *helper* level while adequate for the *main-theorem* level.
- **Hint precision**: **precise** — all four `\lean{...}` tags use fully qualified names that match the file.
- **Generality**: **matches need** — the χ-identity is stated for general `g` (as the blueprint intends), and the genus-zero theorem threads H¹-vanishing as a premise as explicitly designed.
- **Recommended chapter-side actions**:
  - **Add a `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_of_shortExact_skyscraper}` lemma block** in the χ-identity section (immediately before or after the existing "Lean reference note" at the end of the `thm:euler_char_eq_deg_plus_one_minus_genus` proof). This pin would give the plan agent a blueprint handle to dispatch closure of the remaining sorry, and would let `sync_leanok` track it.
  - **Investigate whether `sync_leanok` detects transitive sorries through `private` helpers.** If it does not, remove `\leanok` from the proof blocks of `thm:euler_char_eq_deg_plus_one_minus_genus` and `thm:riemannRoch_genus_zero` until the helper chain is fully closed.
  - Update the stale `## Status (iter-174)` file-header comment in `RRFormula.lean` to reflect iter-185 state (minor housekeeping).
  - Update the stale docstring of `finrank_H0_toModuleKSheaf_eq_one` to drop the "Tier-3 honest typed sorry" language (it was closed in iter-185).

---

## Severity summary

| Finding | Severity |
|---|---|
| `eulerCharacteristic_of_shortExact_skyscraper` (L329) — sorry body on substantive claim, not chapter-pinned | **major** |
| `\leanok` on proof blocks of two main theorems while transitive sorry chain exists | **major** |
| Stale file-header comment L35–44 ("iter-174 Lane F file-skeleton") | minor |
| Stale docstring L228–230 for `finrank_H0_toModuleKSheaf_eq_one` (says "Tier-3 typed sorry" but declaration is now closed) | minor |

**Overall verdict**: The four chapter-pinned declarations are correctly stated and faithfully implemented (signatures match, proof structures follow the blueprint sketches); the file is in sound structural shape, but two **major** issues require plan-phase action: the remaining typed sorry (`eulerCharacteristic_of_shortExact_skyscraper`) needs a blueprint `\lean{...}` pin to be schedulable, and the `\leanok` proof-block markers on the two main theorems should be verified against `sync_leanok`'s transitive-sorry detection semantics before being treated as "proof closed."
