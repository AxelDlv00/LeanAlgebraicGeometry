Both threads are horizon-started (their closure is horizon's, not mine) and their latest entries are horizon's own acknowledgments confirming my work is durable — no question awaits me. These are bookkeeping threads horizon owns; I've addressed every action requested. My work is complete, verified, durable, and coordinated.

## Progress

- `Curve/P1PicComparison.lean` (new, rooted, 0 sorries, axiom-clean `[propext, Classical.choice, Quot.sound]`, `lake env lean` EXIT=0): the étale↔Zariski Picard comparison at ℙ¹, **unconditional**. Feeding my landed `P1.overSection k K` into the field-point comparison discharges the curve-point (σ) hypothesis, so over every field extension K/k: `P1.relPicToPicEt_surjective` / `relPicToPicEtEquiv` (MulEquiv `relPic ≃* picEt`) / `relPicToPicEt_bijective` hold with **no hypothesis** (the three `P1.asOver k` curve binders + `GeometricallyReduced` all `inferInstance`). Plus `eq_one_of_relPicDeg_eq_zero` (deg-0 `relPic(ℙ¹_K)` trivial, from χ=1) and the capstone `P1.subsingleton_pic0Subgroup` via the honest route. Commits `e89fd3b2e6`, `aeeeb7e710`, docstring-fix `7fb6f696df`.
- `AlgebraicJacobian.lean`: +1 root import.
- Roadmap `AJCR.w4-rep.datum.p1-comparison`: created, done, owner released (`a281e135ae` + release commit).

## Why I stopped

Objective **partly advanced** — Pic representability is not closed. My verified substrate factored the remaining ring-case wall into exactly two facts and split them with pic-c:

- The field-test `pic⁰` vanishing at ℙ¹ (`pic0Subgroup_coe_eq_one`) rides on precisely (1) surjectivity of `relPicToPicEt` onto `picEt` over the test and (2) triviality of degree-0 `relPic(ℙ¹_·)`.
- pic-c (I-1720) **accepted fact (2)** — ring-level via their two-chart Laurent computation. Fact (1), ring-level surjectivity, remains the genuine open honesty wall: effectivity over a ring base uses field cofinality of étale covers (`exists_finiteSeparableField_algHom`), which does not generalize — a multi-session substrate problem, kept on the pic-g lane.
- pic-c's I-1715 seminormality scare is retracted and confirmed sound (Traverso–Swan lives on the 𝔸¹ chart, not `relPic(ℙ¹_A)`), so the arbitrary-ring target is not obstructed.

## Issues

- Work-reviewer (I-1723) confirmed the file non-vacuous, no new hypothesis, axiom-clean, honest novelty framing; found two phantom docstring names + an undisclosed sibling duplicate — all fixed in `7fb6f696df` (docstring only).
- Standing I-1222 shared-index staged-deletion hazard is live; all four of my commits used fresh private indexes, each verified HEAD-vs-disk blob-identical and touching only my paths. No clobbers; all four commits are ancestors of final HEAD.

## Next

- **Ring-level `relPicToPicEt` surjectivity at ℙ¹** (fact 1): effectivity-over-a-ring — descent of Picard classes along module-finite étale ring covers (Kleiman C2 without field cofinality), absent from mathlib.
- When pic-c lands fact (2) over a ring A, `P1.pic0Subgroup_coe_eq_one` transcribes field→ring verbatim, giving `∀ A, Subsingleton (pic0Subgroup (P1.asOver k) (overSpec k A))` → `jacobianData_of_overSpec_subsingleton` → the ℙ¹ Jacobian datum.
