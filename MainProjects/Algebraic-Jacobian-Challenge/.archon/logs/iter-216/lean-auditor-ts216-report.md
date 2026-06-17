# Lean Audit Report

## Slug
ts216

## Iteration
216

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 4 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 2 flagged
- **excuse-comments**: 0 flagged
- **notes**:

  **Outdated comments**

  - **[OC-1] Lines 37–72 (module-level "Status" docstring)**: Claims the file is
    "**iter-202 Lane TS** file-skeleton: each of the 4 pinned declarations carries
    … a `sorry` body." This is false in three out of four respects:
    (a) `tensorObj` (line 829) has a complete, non-sorry body lifting
        `PresheafOfModules.Monoidal.tensorObj` through sheafification — exactly the
        "iter-203+ body" the docstring promises for a future iter.
    (b) `tensorObj_functoriality` (line 846) has a complete, non-sorry body using
        `sheafification.map (MonoidalCategory.tensorHom …)`.
    (c) `AlgebraicGeometry.Scheme.Modules.monoidalCategory` is listed as "3rd
        blueprint-pinned declaration" but has been deliberately REMOVED from the
        file (see §2 comment, lines 862–873).
    Only `addCommGroup_via_tensorObj` (line 1267) remains a `sorry`. The module
    header's description of the file's completion state is now substantially wrong
    and misleads any reader about which declarations still need work.

  - **[OC-2] Line 826 (`tensorObj` docstring)**: Says "iter-202 Lane TS scaffold:
    the body is a typed `sorry`; the iter-203+ body lifts
    `PresheafOfModules.Monoidal.tensorObj` through sheafification." The "iter-203+
    body" is already present. The `sorry` claim is false.

  - **[OC-3] Line 843 (`tensorObj_functoriality` docstring)**: Says "iter-202 Lane
    TS scaffold: the body is a typed `sorry`; the iter-203+ body inherits the
    morphism action from `PresheafOfModules.Monoidal.tensorObj` under
    sheafification." Same issue: the body is real, not a sorry.

  - **[OC-4] Lines 605 + 692 (ROUTE label inconsistency)**: The sorry body of
    `isLocallyInjective_whiskerLeft_of_W` (line 605) opens with
    `-- ROUTE (e) residual:`, but both the `WhiskerOfW` section header (line 555)
    and the declaration's own docstring (line 583) label this approach **ROUTE (d)**.
    The `StalkLinearMap` section header (line 692) also says "ROUTE (e), ingredient
    d.1", perpetuating the inconsistency. A reader trying to match sorry comments to
    strategy documents encounters two different route labels for the same
    mathematical approach.

  **Bad practices**

  - **[BP-1] `@[simp]` on a `letI`-parameterised lemma (lines 197–207)**:
    `restrictScalarsRingIsoTensorEquiv_apply_tmul` is marked `@[simp]`, but its LHS
    and RHS both live inside a `letI` context (`_iA`, `_iB`, `_iT`). The `simp`
    tactic compares terms against the normal instance environment; the `letI`-local
    `Module R A` instances won't unify with whatever `Module R A` instance `simp`
    sees in a call site. In practice this lemma is likely to silently fail to fire.
    If it is intended to be used by `simp`, a separate `@[simp]` variant without
    `letI` (using the canonical instances directly) would be safer.

  - **[BP-2] `set_option backward.isDefEq.respectTransparency false` (lines 300,
    316, 333)**: Used as a per-definition option on `restrictScalarsLaxε`,
    `restrictScalarsLaxμ`, and `restrictScalarsLaxMonoidal`. This option makes the
    unifier fold more definitions than the default semi-reducible transparency,
    which can paper over genuine type mismatches and silently accept ill-typed
    terms. The three affected definitions look structurally correct, but the pattern
    signals that their types are awkward to unify directly — a potential maintenance
    liability if the Mathlib pinned commit changes the transparency of involved
    definitions.

  **Sorry sites — accuracy assessment**

  The four remaining `sorry` sites (lines 632, 1185, 1228, 1267) are each assessed
  for docstring/comment accuracy:

  - **Line 632 (`isLocallyInjective_whiskerLeft_of_W`)**: The sorry body comment
    accurately records the two residual gaps (d.1-bridge and d.2) and the iter-214
    partial progress on d.1. Content is honest. Subject to the ROUTE naming
    inconsistency OC-4 above.

  - **Line 1185 (`tensorObj_restrict_iso`)**: The iter-216 update comment (lines
    1159–1176) accurately reports H2 closed and states the MAKE-OR-BREAK FINDING
    that H1 (presheaf `pushforwardPushforwardAdj`) is genuinely on the critical
    path and the "free-cover shortcut" does not discharge it. Comment is honest and
    up-to-date.

  - **Line 1228 (`exists_tensorObj_inverse`)**: Docstring says "typed `sorry`; the
    iter-203+ body builds the dual and the contraction isomorphism." Honest: the
    sorry is unelaborated, no misleading progress claims.

  - **Line 1267 (`addCommGroup_via_tensorObj`)**: Docstring says "iter-202 Lane TS
    scaffold: typed `sorry`." Honest. The design note about using a `def` instead
    of a global `instance` to avoid a diamond is technically accurate.

  **New declarations (focus area, lines 197–280)**

  All six new declarations in `RestrictScalarsRingIsoTensor` were inspected for
  honesty and proof validity:

  - **`restrictScalarsRingIsoTensorEquiv` (lines 115–193)**: The forward map (lift
    via `TensorProduct.lift`) and backward map (built via `TensorProduct.liftAddHom`
    then wrapped as `R`-linear) are explicitly spelled out. The inverse proofs use
    `TensorProduct.induction_on` and are self-contained. Definitionaly correct.

  - **`restrictScalarsRingIsoTensorEquiv_apply_tmul` (lines 197–207)**: The `simp
    only` proof unfolds `restrictScalarsRingIsoTensorEquiv` and applies
    `TensorProduct.lift.tmul`. Correct. (Subject to the `@[simp]` / `letI`
    effectiveness concern in BP-1.)

  - **`restrictScalars_isIso_μ` (lines 219–232)**: Uses
    `ConcreteCategory.isIso_iff_bijective` (appropriate for `ModuleCat`) to reduce
    to bijectivity, then constructs `hfun : ⇑μ = ⇑equiv` by tensor induction
    (zero/tmul/add cases), and closes via `LinearEquiv.bijective`. The `erw` at
    line 228 (`ModuleCat.restrictScalars_μ_tmul`) is appropriate because the goal
    type has a universe/instance elaboration that `rw` cannot handle directly. No
    vacuous shortcut detected.

  - **`restrictScalars_isIso_ε` (lines 237–244)**: Uses `ModuleCat.restrictScalars_η`
    to identify `⇑ε = ⇑e.toRingHom = ⇑e`, then closes by `e.bijective`. The naming
    clash (`η` vs `ε`) is a Mathlib naming convention difference, not a proof error.

  - **`restrictScalarsMonoidalOfRingEquiv` (lines 252–259)**: A genuine
    `Functor.Monoidal` structure obtained by `Functor.Monoidal.ofLaxMonoidal` after
    installing the two `IsIso` hypotheses via `haveI`. Not a disguised sorry. The
    `@[implicit_reducible]` attribute is a valid Lean 4 reducibility annotation for
    instance inference.

  - **`restrictScalars_isIso_μ_of_bijective` (lines 266–271)** and
    **`restrictScalars_isIso_ε_of_bijective` (lines 275–279)**: Both reduce to the
    ring-equiv case via `RingEquiv.ofBijective` and `RingHom.ext`. Correct and
    honest.

  **Other observations**

  - `W_whiskerLeft_of_flat` / `W_whiskerRight_of_flat` (lines 521–552): Complete,
    axiom-clean proofs. The section comment (lines 556–558) explicitly marks them as
    "OFF the associator critical path (iter-212 finding)." These are potentially dead
    code for the current approach. They may have independent value as Mathlib
    supplements but are not consumed by the visible proof graph in this file.

  - `tensorObjOnProduct` (lines 1236–1239): No direct `sorry` in the body, but it
    calls `tensorObj_isLocallyTrivial` which in turn calls `tensorObj_restrict_iso`
    (sorry at line 1185). The definition is sorry-backed and cannot be used as a
    real mathematical fact until `tensorObj_restrict_iso` is closed. The docstring
    does not warn the reader of this dependency.

---

## Must-fix-this-iter

None. No declaration has a body that contradicts its stated type, no axiom misuse,
no vacuous/weakened definitions, and no excuse-comments on load-bearing claims. The
four sorrys are honest. The six new declarations are genuine.

---

## Major

- `TensorObjSubstrate.lean:37–72` — Module-level "Status" docstring claims "each
  of the 4 pinned declarations carries a `sorry` body"; `tensorObj` and
  `tensorObj_functoriality` now have real bodies, and `monoidalCategory` has been
  removed. The header misrepresents the file's completion state to every reader.

- `TensorObjSubstrate.lean:826` — `tensorObj` docstring says "body is a typed
  `sorry`; the iter-203+ body lifts …". The iter-203+ body IS already in place.

- `TensorObjSubstrate.lean:843` — `tensorObj_functoriality` docstring says "body is
  a typed `sorry`; the iter-203+ body inherits …". Same: body is real.

- `TensorObjSubstrate.lean:605,692` — Route label inconsistency: sorry body and
  `StalkLinearMap` section header use "ROUTE (e)"; section and docstring use "ROUTE
  (d)". Strategy readers tracking sorry bodies by route label will be confused.

---

## Minor

- `TensorObjSubstrate.lean:197` — `@[simp]` on `restrictScalarsRingIsoTensorEquiv_apply_tmul`
  with `letI` in the type may prevent the lemma from firing in simp contexts; the
  `letI`-introduced instances will not unify with global instances in a call site.

- `TensorObjSubstrate.lean:300,316,333` — `set_option backward.isDefEq.respectTransparency false`
  used for three definitions. Non-standard transparency override; can mask type
  mismatches.

- `TensorObjSubstrate.lean:521–552` — `W_whiskerLeft_of_flat` /
  `W_whiskerRight_of_flat` appear to be dead code for the current approach (the
  surrounding comment flags them as "OFF the associator critical path").

- `TensorObjSubstrate.lean:1236–1239` — `tensorObjOnProduct` docstring does not
  mention that it is transitively sorry-backed via `tensorObj_isLocallyTrivial →
  tensorObj_restrict_iso (sorry)`.

---

## Excuse-comments (always called out separately)

None found. The four `sorry` sites have accurate, substantive comments explaining
what is missing. None of the following phrases appear:
- "temporary wrong definition"
- "placeholder"
- "TODO: replace"
- "will fix later"
- "wrong but works"

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 4 (all outdated comments; no wrong code)
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The file is mathematically honest — the six new `RestrictScalarsRingIsoTensor` declarations are genuine, the four sorry sites are accurately labelled, and no disguised-sorry or vacuous-definition patterns were found. The main quality debt is that several docstrings and the module-level "Status" header were not updated when `tensorObj` and `tensorObj_functoriality` received real bodies, creating a false picture of which declarations still need proof work.
