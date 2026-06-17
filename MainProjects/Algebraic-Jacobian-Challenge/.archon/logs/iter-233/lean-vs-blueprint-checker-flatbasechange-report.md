# Lean ↔ Blueprint Check Report

## Slug
flatbasechange

## Iteration
233

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)

- **Lean target exists**: yes (line 76)
- **Signature matches**: yes
  - Blueprint: `g^*(f_* F) → f'_*((g')^* F)`, built as the adjoint mate of `f_*` applied to the unit of the `((g')^*, (g')_*)`-adjunction together with pseudofunctoriality of pushforward and commutativity of the square.
  - Lean: `(Scheme.Modules.pullback g).obj ((pushforward f).obj F) ⟶ (pushforward f').obj ((Scheme.Modules.pullback g').obj F)` — matches verbatim.
  - The parameter `comm : g' ≫ f = f' ≫ g` correctly records that only commutativity (not cartesianness) is needed for the definition.
- **Proof follows sketch**: yes — the body uses the adjunction transpose `(pullbackPushforwardAdjunction g).homEquiv` and chains `(pullbackPushforwardAdjunction g').unit.app F`, `(pushforwardComp g' f).hom`, `(pushforwardCongr comm).hom`, and `(pushforwardComp f' g).inv` in exactly the sequence the blueprint describes. Axiom-clean, no sorry.
- **Notes**: Blueprint has `\leanok` on the statement, no proof block `\leanok` (definitional body closes the block). Consistent.

---

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)

- **Lean target exists**: yes (line 174)
- **Signature matches**: yes
  - Blueprint: `f` affine, square cartesian (`IsPullback`), conclusion `IsIso` of the base-change map.
  - Lean: `(h : IsPullback g' f' f g) [IsAffineHom f] (F : X.Modules) : IsIso (pushforwardBaseChangeMap f g f' g' h.w F)` — matches.
- **Proof follows sketch**: partial
  - Blueprint proof sketch: "local on S and S' → reduce to fully affine schemes → use tilde dictionary → reduce to `(R' ⊗_R A) ⊗_A M ≅ R' ⊗_R M`."
  - Lean proof (commented-out outline): starts with `rw [Modules.isIso_iff_isIso_app_affineOpens]` (the new locality criterion from this iter), then reduces to a per-affine-open goal. The blueprint's "local on S and S'" argument is conceptually the same step but the Lean uses the sharper affine-opens criterion `isIso_iff_isIso_app_affineOpens` rather than an explicit cover argument. The actual per-open goal (tilde dictionary + `cancelBaseChange`) remains `sorry`.
  - Proof body ends with a single `sorry`.
- **Notes**:
  - Blueprint has `\leanok` on the **statement** block — correct, meaning the declaration exists (at least a sorry). The **proof** block has no `\leanok` — correct, since the proof is not closed.
  - The blueprint's `% NOTE:` comment explicitly acknowledges the sorry and its cause (missing tilde dictionary). This is documented deferred work, not hidden-placeholder code.
  - Minor strategy divergence: the blueprint's proof outline says "local on S and S'" (cover argument implied) but the Lean starts with the direct affine-opens criterion. The end mathematics is the same, but the blueprint should mention `isIso_iff_isIso_app_affineOpens` explicitly (see Blueprint adequacy below).

---

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)

- **Lean target exists**: yes (line 207)
- **Signature matches**: yes
  - Blueprint: `g` flat, `f` quasi-compact and quasi-separated, square cartesian, conclusion `IsIso` of the base-change map.
  - Lean: `(h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [QuasiSeparated f] (F : X.Modules) : IsIso (pushforwardBaseChangeMap f g f' g' h.w F)` — matches exactly.
- **Proof follows sketch**: N/A (proof body is `sorry`; the Lean file comments describe the intended Čech-complex strategy which mirrors the blueprint's proof sketch).
- **Notes**:
  - Blueprint has `\leanok` on the **statement** block; no `\leanok` on the **proof** block — consistent with sorry proof.
  - Blueprint `% NOTE:` acknowledges dependency on Čech-cohomology / affine-cover infrastructure absent from Mathlib. Documented deferred work.

---

## Red flags

### Placeholder / suspect bodies

- `affineBaseChange_pushforward_iso` (line 198): body ends with `:= sorry`. The blueprint **does not claim the proof is closed** (`\leanok` is on the statement, not the proof block; the proof block's `% NOTE:` explicitly says "Lean proof incomplete"). Per project convention (`\leanok` on statement = "at least a sorry present") this is **not** a hidden placeholder — it is accurately accounted for. No must-fix escalation.
- `flatBaseChange_pushforward_isIso` (line 220): same situation — sorry, blueprint-acknowledged.

Both sorries are filed as known, documented, and expected for this iteration. They are **not** surprise placeholders.

### Excuse-comments

- Lines 184–197: the Lean file contains a multi-line comment block beginning "Remaining goal: `IsIso (Hom.app …)`" inside `affineBaseChange_pushforward_iso`. This is a proof-strategy roadmap comment, not an excuse-comment. It correctly describes what the `sorry` is standing in for and references `informal/affineBaseChange_pushforward_iso.md`. Acceptable.

### Axioms / Classical.choice on non-trivial claims

None found. The three locality lemmas are axiom-clean, proved theorems.

---

## Unreferenced declarations (informational)

The following three declarations appear in the Lean file but have **no `\lean{...}` reference** in the blueprint chapter:

1. `Modules.isIso_iff_isIso_stalkFunctor_map` (line 99) — stalk-local criterion for `Scheme.Modules` morphisms.
2. `Modules.isIso_of_isIso_app_of_isBasis` (line 125) — basis-local criterion.
3. `Modules.isIso_iff_isIso_app_affineOpens` (line 161) — affine-open locality criterion.

These are **substantive declarations**, not trivial helpers:
- Each is a proved theorem (axiom-clean, no sorry).
- `isIso_iff_isIso_app_affineOpens` is **the first formal step** in the current `affineBaseChange_pushforward_iso` proof (line 182: `rw [Modules.isIso_iff_isIso_app_affineOpens]`), making it a key piece of the affine reduction.
- Their scope is clearly Mathlib-gap-bridging infrastructure (project-local); they merit a supplement subsection in the blueprint so future provers understand the proof structure.
- The Lean file's module-docstring (`/-! ## Project-local Mathlib supplement — locality of isomorphisms for Scheme.Modules -/`) acknowledges the gap, but the blueprint chapter is silent on these lemmas.

**Flag: blueprint chapter is missing `\lean{...}` blocks for all three.**

---

## Blueprint adequacy for this file

### Coverage
- 3/6 Lean declarations have a `\lean{...}` block: `pushforwardBaseChangeMap`, `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`.
- 3/6 unreferenced: `Modules.isIso_iff_isIso_stalkFunctor_map`, `Modules.isIso_of_isIso_app_of_isBasis`, `Modules.isIso_iff_isIso_app_affineOpens`.
- Of the 3 unreferenced: 0 trivial helpers, **3 substantive declarations** (flagged above).

### Proof-sketch depth
**Under-specified** for `lem:affine_base_change_pushforward`:
- The blueprint's proof begins "The assertion is local on S and on S'..." and immediately jumps to the fully affine case. It does not name the Lean mechanism for this locality reduction.
- The Lean's first formal step (`rw [Modules.isIso_iff_isIso_app_affineOpens]`) uses the affine-open criterion, which is not mentioned anywhere in the proof sketch. A future prover reading only the blueprint would not know this criterion exists or that it is the right tool.
- The blueprint's `% NOTE:` in the proof source quote does mention "iso local on an affine cover criterion for SheafOfModules maps" as a missing Mathlib ingredient, but this is in a comment, not in the proof sketch body.

**Adequate** for `def:pushforward_base_change_map` and `thm:flat_base_change_pushforward`:
- The definition's construction is described in enough detail to guide the Lean adjunction-transpose argument.
- The flat base change proof sketch (Čech complex → flatness commutes with H^0) matches the Lean's commented proof outline. The proof is deferred due to missing infrastructure, not a blueprint adequacy issue.

### Hint precision
**Precise** for the three referenced declarations — `\lean{...}` names match the actual Lean identifiers and the prose descriptions pin the correct Mathlib predicates (`IsPullback`, `IsAffineHom`, `Flat`, `QuasiCompact`, `QuasiSeparated`).

### Generality
**Matches need** for the referenced declarations. The locality lemmas are the case where generality exceeded blueprint scope: the project needed three Mathlib-gap-bridging lemmas that the blueprint did not anticipate.

### Recommended chapter-side actions

1. **Add a `§ Project-local locality criteria` supplement subsection** with three new `\begin{lemma}...\end{lemma}` blocks (one per locality lemma) carrying `\lean{...}` references to `AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map`, `AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis`, and `AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens`. Brief informal statements suffice; a proof sketch noting "stalkwise criterion via `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` + basis locality" and "affine opens form a basis, specialise preceding" would give a future prover the key ideas.

2. **Update the `lem:affine_base_change_pushforward` proof sketch** to mention that the locality reduction is done via `isIso_iff_isIso_app_affineOpens` as a first step, not a Čech-cover argument. One sentence is enough: "By `isIso_iff_isIso_app_affineOpens` it suffices to check the map is an isomorphism on sections over every affine open of S'; over an affine open the tilde dictionary then reduces to the algebraic computation below."

3. **Add `\uses{...}` tags** to `lem:affine_base_change_pushforward` citing the three new locality lemmas once their blueprint blocks exist.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `affineBaseChange_pushforward_iso` body is `:= sorry` | **not a red flag** — blueprint-acknowledged deferred work; statement `\leanok`, proof block unmarked; consistent |
| `flatBaseChange_pushforward_isIso` body is `:= sorry` | **not a red flag** — same reasoning |
| 3 locality lemmas have no `\lean{...}` in blueprint | **major** — substantive proved declarations unreferenced; one is the literal first step of the affine proof |
| Blueprint `lem:affine_base_change_pushforward` proof sketch silent on the locality criterion | **major** — blueprint under-specifies the reduction mechanism; the Lean proof uses a tool the chapter does not name |
| `affineBaseChange_pushforward_iso` proof strategy (affine-opens criterion) diverges from sketch ("local on S and S'") | **minor** — mathematically equivalent, but sketch lacks the key Lean ingredient |

**Overall verdict:** Engine theorem signatures are faithful to the blueprint and both sorries are properly documented; the chapter's gap is the complete absence of `\lean{...}` blocks for the three iter-233 locality lemmas and the missing mention of `isIso_iff_isIso_app_affineOpens` in the affine proof sketch — 0 must-fix-this-iter findings, 2 major blueprint-side gaps requiring a supplement subsection and a proof-sketch update.
