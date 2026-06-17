# Lean Audit Report

## Slug
ts218

## Iteration
218

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 4 flagged
- **suspect definitions**: 1 flagged
- **dead-end proofs**: 3 flagged (3 sorry bodies; 2 with dead supporting infrastructure)
- **bad practices**: 1 flagged (`@[implicit_reducible]` over sorry)
- **excuse-comments**: 0 (none meeting the strict excuse-comment definition)
- **notes**:

  #### Docstring accuracy check (directive priority items)

  - **L990 (`tensorObj`) docstring "fully defined, no `sorry`"** — **ACCURATE.** Body at
    L991–994 is entirely Mathlib calls
    (`PresheafOfModules.sheafification`, `PresheafOfModules.Monoidal.tensorObj`); no
    project-local sorry. ✓

  - **L1005 (`tensorObj_functoriality`) docstring "fully defined, no `sorry`"** — **ACCURATE.**
    Body at L1007–1011 uses `PresheafOfModules.sheafification` + `MonoidalCategory.tensorHom`
    on Mathlib objects; no sorry. ✓

  - **L1373–1399 (`exists_tensorObj_inverse`) in-code blocker comment** — **ACCURATE.** The
    sorry at L1399 is honestly described: the dual `Linv := ℋom_{𝒪_X}(L, 𝒪_X)` cannot be
    constructed because no `MonoidalClosed`/internal-hom on `PresheafOfModules` or
    `SheafOfModules` exists, and no object-level descent is available. The comment does NOT
    launder the sorry as complete; it explicitly says "BLOCKED at step 1: the dual `Linv` has
    no `SheafOfModules`-level construction." ✓

  - **L1406 (`tensorObjOnProduct`) docstring: "iter-202 Lane TS scaffold: typed `sorry`"** —
    **INACCURATE IN THE WRONG DIRECTION.** The body at L1407–1411 is a *real, sorry-free*
    implementation:
    ```
    ⟨tensorObj L.carrier L'.carrier,
        tensorObj_isLocallyTrivial L.isLocallyTrivial L'.isLocallyTrivial⟩
    ```
    The sorry was filled (using `tensorObj_isLocallyTrivial`) but the docstring was not
    updated. Anyone reading only the docstring would incorrectly believe this declaration still
    needs work.

  #### `addCommGroup_via_tensorObj` (L1439–1443)

  - Body is `sorry` at L1443. The docstring (L1418–1438) accurately characterises it as a
    scaffold whose closure depends on `exists_tensorObj_inverse`.
  - **`@[implicit_reducible]` over sorry body** — The attribute at L1439 makes this `def`
    transparent to the Lean elaborator's reducibility inference. In practice: since the def
    is NOT declared `instance`, typeclass synthesis will not find it automatically, so there
    is no route by which the sorry silently satisfies a downstream `AddCommGroup` search.
    The `sorry_analyzer` still sees the `sorry`. So the attribute does **not** mask the sorry
    from project metrics. However, the combination of `@[implicit_reducible]` + sorry body is
    a bad practice: if the elaborator unfolds this def in a definitional equality check, it
    encounters a sorry-filled term that Lean will accept without error, potentially concealing
    proof obligations. The docstring note at L1438 justifies this on linter grounds ("the
    `classType` linter warns without it"), which is a plausible technical reason but still
    bad hygiene.

  #### `isLocallyInjective_whiskerLeft_of_W` (L600–632)

  - Body is `sorry` at L632. The in-code comment (L605–631) accurately describes the two
    residual gaps: (d.1-bridge) the `W`-characterisation bridge for `Opens X`, and (d.2)
    stalk–tensor commutation. The comment explicitly does NOT claim the proof is complete or
    advances any tactic state past the current sorry. ✓

  #### Module header "Status" section (L37–86)

  - Says "**iter-202 Lane TS** file-skeleton: each of the 4 pinned declarations carries
    the *intended* substantive type signature with a `sorry` body."
  - As of iter-218, at least **3 of the 4** pinned declarations are sorry-free:
    1. `tensorObj` — closed ✓
    2. `tensorObj_functoriality` — closed ✓
    3. `monoidalCategory` — deliberately removed (see §2 pivot L1022–1034)
    4. `addCommGroup_via_tensorObj` — still sorry
  - Additionally the PUSH-BEYOND helpers (`tensorObj_restrict_iso`, `tensorObj_assoc_iso`,
    `tensorObjOnProduct`) are closed or partially closed, contrary to the "iter-203+ work"
    framing of the status block.
  - **STALE** — the module header misrepresents the current state significantly.

  #### `tensorObj_assoc_iso` docstring (L1106–1149)

  - Says "**iter-212 status (typed `sorry`**; go/no-go bridge CLEARED, a NEW residual
    located)." The proof at L1150–1193 contains **no `sorry`** — it is **closed** (ends
    with `exact (@asIso _ _ _ _ _ hi1).symm ≪≫ e2 ≪≫ (@asIso _ _ _ _ _ hi3)`). The
    "iter-212 status" label is stale by 6 iterations.
  - Step 1 of the described construction says "(P flat ⇒ right-whiskered `η ∈ J.W` by
    `W_whiskerRight_of_flat`)". The **actual proof** uses
    `PresheafOfModules.W_whiskerRight_of_W` (flatness-free, ROUTE (d)), not
    `W_whiskerRight_of_flat`. The docstring describes the **superseded** flat route; the
    proof uses a fundamentally different (and correct) approach.
  - The inline comment at L1154–1157 correctly says "ROUTE (d)" but this contradicts
    the outer docstring's flat-route description without resolving it.

  #### Dead code — flat-whiskering cluster (L444–552)

  The prover's dead-code claim is **confirmed** for the flat-whiskering cluster:

  - `isLocallyInjective_whiskerLeft_of_flat` (L444): only consumed by `W_whiskerLeft_of_flat`
    (L528). ✓
  - `W_whiskerLeft_of_flat` (L521): only consumed by `W_whiskerRight_of_flat` (L543) and
    comment references. ✓
  - `W_whiskerRight_of_flat` (L537): consumed by **no live proof body** — only by comments
    at L652, L1119, L1130. The `tensorObj_assoc_iso` proof uses `W_whiskerRight_of_W`, not
    this declaration.

  **Verdict**: The chain `isLocallyInjective_whiskerLeft_of_flat → W_whiskerLeft_of_flat →
  W_whiskerRight_of_flat` terminates at `W_whiskerRight_of_flat` which has **zero calls in
  any proof body** inside or outside this file. All three are genuinely dead from the Lean
  proof graph's perspective.

  Note: the declarations are complete, axiom-clean, and mathematically valid; the dead-code
  status is solely a consequence of the ROUTE (d) pivot that made them unnecessary for the
  associator.

  #### Dead code — stalk-linearmap cluster (L691–808)

  The prover's dead-code claim is **confirmed** for the stalk infrastructure:

  - `stalkLinearMap` (L724), `stalkLinearMap_germ` (L765),
    `stalkLinearMap_bijective_of_isIso` (L786), `stalkLinearEquivOfIsIso` (L799):
    these form an internal chain (each builds on the previous), but the chain's sole
    external consumer is `isLocallyInjective_whiskerLeft_of_W`, which **ends in `sorry`**
    at L632 and **does not call any of these** in its body (the body is just `sorry`).

  No other file in `AlgebraicJacobian/` references these four declarations (grep
  across `AlgebraicJacobian/` returns only `TensorObjSubstrate.lean` itself).

  **Verdict**: All four stalk lemmas are effectively dead — they are well-formed preparatory
  ingredients but currently unreachable from any completed proof.

  #### `set_option backward.isDefEq.respectTransparency false` (L300, L316, L333, L901)

  These pragmas are used in several declarations. They are legitimate workarounds for
  definitional equality issues in Lean's elaborator; not a bad practice in context, but
  they indicate structural opacity issues that should eventually be resolved.

  #### Sorry count summary

  | Line | Declaration | Sorry | Comment accuracy |
  |------|-------------|-------|-----------------|
  | 632 | `isLocallyInjective_whiskerLeft_of_W` | yes | accurate |
  | 1399 | `exists_tensorObj_inverse` | yes | accurate |
  | 1443 | `addCommGroup_via_tensorObj` | yes | accurate (but `@[implicit_reducible]` concern) |

  No `native_decide`, `axiom`, or `admit` found anywhere in the file. ✓

---

## Must-fix-this-iter

Per the strict protocol (sorry on load-bearing claims + inaccurate docstrings about sorry status):

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:632` — `isLocallyInjective_whiskerLeft_of_W`
  ends in `sorry`. Load-bearing: it is the sole blocker of `W_whiskerLeft_of_W` /
  `W_whiskerRight_of_W`, which are consumed by the otherwise-closed `tensorObj_assoc_iso`.
  Why must-fix: sorry on a substantive claim whose closure unblocks the associator and
  consequently `tensorObj_isLocallyTrivial`.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1399` — `exists_tensorObj_inverse` ends
  in `sorry`. Load-bearing: it supplies the inverse in the relative Picard group law; without
  it, `addCommGroup_via_tensorObj` cannot close. Why must-fix: sorry on a load-bearing claim
  with documented infrastructure gaps.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1443` — `addCommGroup_via_tensorObj` ends
  in `sorry` under `@[implicit_reducible]`. Load-bearing: this is the iter-204+ closure target
  for the `RelPicFunctor.lean` `addCommGroup` residual. Why must-fix: sorry on the primary
  consumer target; `@[implicit_reducible]` aggravates by making the sorry transparent to
  elaboration.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1406` — `tensorObjOnProduct` docstring
  says "typed `sorry`" but the body at L1407–1411 is a **complete sorry-free implementation**.
  The sorry was filled (using `tensorObj_isLocallyTrivial` + `tensorObj`) without updating the
  docstring. Misleads project tracking into thinking this declaration still needs work.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1107–1149` — `tensorObj_assoc_iso`
  docstring describes the superseded FLAT route ("`W_whiskerRight_of_flat`"; "P flat"; "iter-212
  status typed `sorry`") when the proof is (a) **closed** and (b) uses the flatness-free ROUTE
  (d) with `W_whiskerRight_of_W`. Readers following the docstring to understand the proof will
  be misled into thinking flatness of `P`/`M` was used and that the proof is still sorry.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:37–86` — Module header "Status (iter-202
  Lane TS — file-skeleton scaffold)" is stale by 16 iterations. Claims all 4 pinned
  declarations carry sorry bodies; `tensorObj`, `tensorObj_functoriality`, and
  `tensorObjOnProduct` are now closed. The "iter-203+ work" framing is long obsolete.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1439` — `@[implicit_reducible]` on
  `addCommGroup_via_tensorObj` over a sorry body. While the sorry_analyzer metric is not
  masked (sorry is still in the body), the attribute makes the sorry-filled def transparent to
  the elaborator's reducibility inference; any definitional equality check involving this type
  will unfold to sorry, potentially concealing downstream proof obligations. The linter-based
  justification is valid but does not eliminate the hygiene concern.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:444–552` — Dead code cluster:
  `isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`,
  `W_whiskerRight_of_flat`. Confirmed zero live proof consumers (`W_whiskerRight_of_flat` is
  only referenced in comments; the associator uses `W_whiskerRight_of_W`). The code is
  correct and axiom-clean but dead.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:724–804` — Dead code cluster: the four
  stalk lemmas `stalkLinearMap`, `stalkLinearMap_germ`, `stalkLinearMap_bijective_of_isIso`,
  `stalkLinearEquivOfIsIso`. Their consumer `isLocallyInjective_whiskerLeft_of_W` ends in
  `sorry` and does not call them. No other file references them.

---

## Minor

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:300, 316, 333, 901` — Four uses of
  `set_option backward.isDefEq.respectTransparency false`. These are legitimate workarounds
  but collectively indicate a non-trivial elaboration fragility in the
  `restrictScalarsLaxMonoidal` / `pushforwardPushforwardAdj` declarations that may become
  brittle across Mathlib version bumps.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1154–1157` — In-code comment says
  "ROUTE (d) three-step composite" and "locally-trivial hypotheses are not even consumed"
  but does not note that the outer docstring (L1107–1149) still describes the superseded flat
  route. The inline/docstring inconsistency is the outer docstring's problem, but the inline
  comment does not flag the mismatch.

---

## Excuse-comments (always called out separately)

None found meeting the strict definition (no "TODO replace", "placeholder", "temporary",
"wrong but works", "will fix later" comments attached to declaration bodies). The closest
candidate is `tensorObjOnProduct:1406` ("iter-202 Lane TS scaffold: typed `sorry`"), but
this is a FACTUALLY WRONG STATUS CLAIM (body is complete) rather than an admission of
current wrongness — it warrants a Major flag under stale comments rather than the
excuse-comment category.

---

## Severity summary

- **must-fix-this-iter**: 3 — three sorry bodies on load-bearing claims (L632, L1399, L1443);
  all block downstream work in their files until addressed.
- **major**: 6
- **minor**: 2
- **excuse-comments**: 0 (none meeting the strict definition)

**Overall verdict**: The file is structurally sound — `tensorObj`, `tensorObj_functoriality`,
`tensorObj_restrict_iso`, and `tensorObj_assoc_iso` are axiom-clean and sorry-free, and the
two critical docstrings (L990, L1005) flagged by the directive are now ACCURATE. The three
remaining sorry bodies (L632, L1399, L1443) are known blockers, accurately documented. The
principal new findings are: `tensorObjOnProduct`'s docstring falsely claims a sorry when the
body is complete (major stale-doc); `tensorObj_assoc_iso`'s docstring describes the
superseded flat route when the closed proof uses ROUTE (d) (major misleading); and two
confirmed dead-code clusters (flat-whisker chain + stalk lemmas) are not consumed by any
live proof.
