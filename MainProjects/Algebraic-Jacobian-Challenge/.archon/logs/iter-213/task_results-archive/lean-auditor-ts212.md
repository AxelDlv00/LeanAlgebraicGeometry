# Lean Audit Report

## Slug
ts212

## Iteration
212

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 5 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 2 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **New decl `PresheafOfModules.isIso_sheafification_map_of_W` (lines 373–383) — GENUINE CLOSE.** Axiom check: `propext`, `Classical.choice`, `Quot.sound` only. No `sorry`. The 4-line proof calls `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` and unpacks the two `MorphismProperty.inverseImage` layers. Statement is well-formed and non-vacuous: the hypotheses `IsLocallyInjective J α`, `IsLocallySurjective J α`, `WEqualsLocallyBijective AddCommGrpCat`, and `HasWeakSheafify` are all genuinely consumed. Not over-broad.
  - **New decl `PresheafOfModules.W_whiskerRight_of_flat` (lines 348–363) — GENUINE CLOSE.** Axiom check: `propext`, `Classical.choice`, `Quot.sound` only. No `sorry`. The proof: (i) obtains `J.W ((toPresheaf _).map (F ◁ g))` from `W_whiskerLeft_of_flat`; (ii) identifies `g ▷ F = (β_ M F).hom ≫ (F ◁ g) ≫ (β_ N F).inv` by braiding naturality (the `rw` chain is correct — `BraidedCategory.braiding_naturality_left g F` says `g ▷ F ≫ (β_ N F).hom = (β_ M F).hom ≫ (F ◁ g)`, from which the ← rewrite closes `hconj`); (iii) cancels the braiding isos via `cancel_left/right_of_respectsIso` on `J.W`. No circular reasoning. Statement is non-vacuous.
  - **`tensorObj_assoc_iso` (line 568) — HONEST TYPED SORRY.** Signature `(hM hN hP : IsInvertible _) : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)` matches the intended statement (associator for ⊗-invertible modules). The docstring (lines 524–567) accurately describes both what is now closed (bridge `isIso_sheafification_map_of_W` and `W_whiskerRight_of_flat`) and what remains open (sectionwise flatness not derivable from `IsInvertible`; local-triviality whiskering needed). No weakening or laundering detected.
  - **`tensorObj_restrict_iso` (line 633) — HONEST TYPED SORRY.** Steps 1–3 of the refine chain are filled; Step 4 hits `sorry` at a presheaf-pullback goal. The `lean_verify` tool flags "opaque" at line 669, consistent with the file's own documentation that `PresheafOfModules.pullback` is the opaque abstract left adjoint. The commentary (lines 663–701) correctly identifies two absent Mathlib ingredients (H1: presheaf-level adjunction; H2: strong monoidality of `restrictScalars` along a ring iso). Not over-claiming.
  - **`exists_tensorObj_inverse` (line 741), `addCommGroup_via_tensorObj` (line 781)** — pure `sorry` scaffolds, no comments over-claiming completion.
  - **`tensorObjOnProduct` (lines 753–757)** — has a real body, but transitively sorry via `tensorObj_isLocallyTrivial → tensorObj_restrict_iso`. Documented in comments.
  - **File compiles without errors.** `lean_diagnostic_messages` returns `items: []` for errors and `failed_dependencies: []`.
  - **Outdated module-doc status block (lines 37–45):** "Status (iter-202 Lane TS — file-skeleton scaffold)" and "the bodies are iter-203+ work" — we are at iter-212 and the sorry bodies have not been filled. The module-level description no longer reflects file state.
  - **Outdated inline docstring timestamps** on `tensorObj` (line 406), `tensorObj_functoriality` (lines 419–428), `exists_tensorObj_inverse` (lines 738–740), `addCommGroup_via_tensorObj` (lines 773–776): all claim "iter-203+ closure target". We are now 10 iterations past that; the claim is stale (though not a false claim of completion).
  - **`set_option backward.isDefEq.respectTransparency false`** used at lines 111, 127, 144 in `restrictScalarsLaxε`, `restrictScalarsLaxμ`, and `restrictScalarsLaxMonoidal`. This non-standard option disables transparency in definitional equality checking. It is a workaround that should carry an explanation of which specific defeq failure it suppresses (and why the suppression is safe). Currently there is no comment at any of the three sites.
  - **Deprecated `CategoryTheory.Sheaf.val` API** (lines 409, 426, 471, 488, 490, 500, 502, 510, 512, 520): compiler warns 11 times that `.val` is deprecated and `ObjectProperty.obj` should be used. These are load-bearing in the sorry-bodied and non-sorry defs alike; they will silently break on the next Mathlib bump that removes the alias.
  - **Unused `ext` pattern `r` at line 120** (inside `restrictScalarsLaxε`'s naturality proof): `ext` does not consume the `r` pattern. Cosmetic but indicates the `ext` call is more powerful than needed; a plain `intro` would be cleaner.
  - **`@[implicit_reducible]` on `addCommGroup_via_tensorObj` (line 780)**: this attribute on a `noncomputable sorry`-bodied def has no semantic effect (the def is not a `abbrev` or type alias, so `implicit_reducible` changes nothing). Confusing.
  - **`Ab.{u}` vs `AddCommGrpCat` inconsistency**: `W_whiskerLeft_of_flat` and `W_whiskerRight_of_flat` hypothesize `[J.WEqualsLocallyBijective Ab.{u}]`; `isIso_sheafification_map_of_W` hypothesizes `[J.WEqualsLocallyBijective AddCommGrpCat]`. These are definitionally equal in Mathlib but the notational inconsistency means callers must unify the instances manually.

---

## Must-fix-this-iter

None.

- The two new proven declarations are axiom-clean with no sorry.
- The typed sorrys are honest (signatures match intended statements; no false claims of completion in comments).
- No weakened/fake definitions, no unauthorized axioms, no excuse-comments, no `sorry`-laundering detected.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:37–45` — **Outdated module-doc status block.** "Status (iter-202 Lane TS — file-skeleton scaffold)" with "iter-203+ work" language is 10 iterations stale. The status description should reflect iter-212 state (bridge lemmas now closed; remaining residual is flatness/local-triviality whiskering).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:406,419,738,773` — **Outdated inline docstring timestamps** on four sorry-bodied decls claim "iter-203+ closure target". We are at iter-212; these give a false impression of near-term closure that does not match project history.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:111,127,144` — **`set_option backward.isDefEq.respectTransparency false` without justification.** Used at three call sites in the `restrictScalars` lax-monoidal supplement. This non-standard solver option suppresses transparency in `isDefEq` and is a workaround for an unidentified defeq friction; no comment explains which specific failure it papers over or why the suppression is safe. Absence of explanation makes this a latent fragility.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:409,426,471,488,490,500,502,510,512,520` — **Deprecated `CategoryTheory.Sheaf.val` API.** 11 compiler warnings: `.val` on `Sheaf` is deprecated; the correct accessor is `ObjectProperty.obj`. Present in both sorry-free defs (`tensorObj`, `tensorObj_functoriality`, `tensorObjIsoOfIso`, `tensorObj_unit_iso`, `tensorObj_left_unitor`, `tensorObj_right_unitor`, `tensorObj_braiding`) and elsewhere. Will silently break on future Mathlib upgrades.

---

## Minor

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:120` — **Unused `ext` pattern `r`** in `restrictScalarsLaxε`'s naturality proof. Compiler warns. The `ext r` should be `ext` (and the `r` case is never used), or a plain `intro`.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:780` — **`@[implicit_reducible]` on a sorry-bodied `noncomputable def`.** No effect; probably a copy-paste from a type-alias context. Should be removed.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:332,376` — **`Ab.{u}` vs `AddCommGrpCat` notational inconsistency** in `[J.WEqualsLocallyBijective _]` hypotheses. Definitionally equal but forces callers to unify the instance.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:669` — **"opaque" pattern in `lean_verify`** for `W_whiskerRight_of_flat`. This warning surfaces from the sorry body of `tensorObj_restrict_iso` which is reachable via the axiom graph. The file's own comments document the opaque `PresheafOfModules.pullback` as the obstacle. Informational only.

---

## Excuse-comments (always called out separately)

None. The sorry-bodied declarations carry accurate status notes, not claims of correctness. The "iter-202 Lane TS scaffold" language is outdated but does not assert the code is correct or complete.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 4 (deprecated API × 11 occurrences; outdated module status; outdated inline timestamps × 4 sites; unexplained `set_option backward.isDefEq.respectTransparency false` × 3 sites)
- **minor**: 4 (unused `ext` pattern; spurious `@[implicit_reducible]`; `Ab`/`AddCommGrpCat` inconsistency; informational opaque warning)
- **excuse-comments**: 0

Overall verdict: the file is in honest condition — both new proven declarations are axiom-clean and their proofs are genuine, all typed sorrys faithfully represent their intended statements without weakening or laundering, and the file compiles without errors; the open issues are documentation staleness, a deprecated API sweep, and an unexplained solver option that should be commented.
