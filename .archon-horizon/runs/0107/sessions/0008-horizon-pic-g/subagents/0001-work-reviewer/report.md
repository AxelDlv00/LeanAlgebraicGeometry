Findings filed as I-1723. The durability concern (I-1719) is already resolved at HEAD. I'm not filing a memory — the lesson here (docstring-cited names must be grepped) is already captured by existing memories `cited-names-need-#check-not-grep` and `check-the-statement-not-the-name`.

## Verdict: CONVERGING — real, verified content, with fixable docstring defects and no new math

The two commits land a genuinely non-vacuous, axiom-clean file. The section hypothesis is honestly discharged, no new binder is introduced, and the capstone is a real statement over a real (Subgroup-valued, hence inhabited) type. The problems are cosmetic-but-concrete: two phantom names in the module docstring, five dead declarations, and an undisclosed duplicate. Nothing rises to a mathematical error or vacuity.

### What checks out
- **Not vacuous.** `pic0Subgroup C T` is a `Subgroup (picEt C T)` (Pic0Functor.lean:107), so it always contains `1` — a real, inhabited type. `subsingleton_pic0Subgroup` asserts genuine collapse, not empty-type triviality.
- **No new hypothesis.** The only binder is `variable (k) [Field k] (K) [Field K] [Algebra k K]` (line 75) — the field data itself, plus the `P1.asOver k` curve binders and `GeometricallyReduced`, all `inferInstance`. The `σ` binder of the consumed comparison lemmas is discharged by the real construction `P1.overSection` (P1Section.lean:72, `Over.homMk (specPoint …)`, no sorry).
- **Section-fed comparison lemmas exist with the claimed signatures** (`relPicToPicEt_surjective_of_section`, `relPicToPicEtEquiv_of_section`, `relPicToPicEt_bijective_of_section` in PicEtUnitFieldComparison.lean:132/107/122), and the P1-level surjectivity/equiv are genuinely new (no pre-existing P1 instance).
- **Durability**: file at HEAD `aeeeb7e710` is byte-identical to disk (180 lines), root import committed. The earlier durability alarm (I-1719) is resolved.
- **Honest framing on novelty**: docstrings never claim the pic⁰ vanishing is new mathematics; they explicitly call it "the template the ring case is to reproduce."

### Concrete defects (filed as I-1723)
1. **Two phantom names in the module docstring.**
   - Line 38 cites `P1.relPicDeg_eq_zero_iff` — does not exist. The real theorem is `eq_one_of_relPicDeg_eq_zero`, and it is **one-directional** (`relPicDeg = 0 → = 1`), not an "iff." The bullet both names a nonexistent decl and mischaracterizes the shape.
   - Line 45 cites `P1.subsingleton_relPicDegZero` — does not exist. Real name: `relPicDeg_eq_zero_subsingleton`.
   Both grep to only their own docstring mention project-wide.
2. **Five dead declarations** (unused by the capstone and unreferenced anywhere): `relPicToPicEt_bijective`, `relPicToPicEtEquiv_apply`, `eq_of_relPicDeg_eq`, `relPicDeg_eq_zero_subsingleton`, and — notably — `picEt_eq_one_of_relPicDeg_symm_eq_zero`, the "same on the étale side" theorem the docstring foregrounds. The capstone `pic0Subgroup_coe_eq_one` routes directly through `relPicToPicEt_surjective` + `eq_one_of_relPicDeg_eq_zero`, bypassing the MulEquiv-transport theorem entirely.
3. **Undisclosed type-identical duplicate.** `subsingleton_pic0Subgroup` (line 173) has the exact same statement and binders as the landed `P1.subsingleton_pic0Subgroup_overSpec_field` (Pic0VanishingFieldTest.lean:172), which proves it via the `degAff` route. An alternate honest-route reproof is legitimate and the docstrings don't overclaim, but they never cite the sibling — a reader can't tell the conclusion already exists at HEAD.

Relevant paths:
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/P1PicComparison.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0VanishingFieldTest.lean` (pre-existing duplicate at :172)
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicEtUnitFieldComparison.lean` (consumed section lemmas)
