The gate is closed. Final report:

## Summary

**`Scheme.HasRigidPushforward` went from a hypothesis with no producer to a proved global instance with a concrete witness.** The one open statement the previous session isolated — `RigidPushforwardGammaBaseChange` — is a theorem; the gate is `Adelic.instHasRigidPushforwardOfCurve`; ℙ¹ is exhibited satisfying its three hypotheses, so it is non-vacuous by exhibition rather than argument. Six commits, two new modules (~570 lines), all axiom-clean.

The route was **shorter than the one recorded for it**. `RigidPushforwardAffineDescent.lean` carried four "corrections" from an earlier adversarial re-check; two were wrong. Correction 1 said to avoid a flatness obligation that is free on this campaign; correction 4 predicted a congruence helper that was never needed, because `Function.Surjective ⇑d` mentions only the underlying function while the module structures are instance arguments — so the ℙ¹ statement and the `C_A` statement are literally the same proposition and one `exact` crosses the propositional `q = π_A ≫ p`.

## Progress

- `Picard/RigidPushforwardGammaBaseChange.lean`: new, 328 lines. `exists_gammaBaseChange_of_kerPure` (H⁰ commutes with affine base change, `f` **not** assumed affine — the case the frontier file called "no infrastructure at all"); `rigidPushforwardGammaBaseChange_proved`; the gate instance; the three extraction theorems restated *without* the `[HasRigidPushforward C]` binder, so the build enforces "consumers synthesize".
- `Picard/RigidPushforwardP1Witness.lean`: new, ~240 lines. Closes two instances the tree recorded as open — `GeometricallyIntegral (Proj ℤ[X₀,X₁] → ⊤)`, which `P1Constants.lean` called "the *whole* remaining B3-H0 frontier" and "a missing mathlib fact about `Proj`" (twelve lines: the test square's base is terminal), and `SmoothOfRelativeDimension 1 ((p1Over k).hom)`. Then `hasRigidPushforward_p1Over` and `hasRigidPushforward_of_geometricallyIrreducible` (the gate at the *challenge's own* hypothesis bundle).
- `Picard/{RigidPushforward,Gate,Transfer,Instance,AffineDescent,P1Constants}.lean`: docstring-only, ten stale claims corrected across two rounds.

Verified from the fully rooted `import AlgebraicJacobian`: `lake build` → **8744 jobs green**; `#print axioms` on all ten declarations → `[propext, Classical.choice, Quot.sound]`.

## Issues

- **Four rounds of the same documentation defect on this task.** A review found eight sites still asserting "no instances anywhere in the tree" one commit after the instance landed — in the file declaring the class, and quoted approvingly by my new module. My repair commit then introduced two more in the witness module, one of which was *false*: I wrote that the challenge's curve "has genus ≥ 1", but `references/challenge.lean` has no genus binder at all, so ℙ¹ satisfies the challenge's complete bundle and my hedge understated my own result.
- **`lake env lean` stalls behind the lake lock** when sibling runs hold it (one call blocked 9 min at 1.2 s CPU). Bypassed with `lean` directly plus the lakefile's `leanOptions` — necessary, since `weak.linter.mathlibStandardSet` is what turns the style linters on.
- Heavy contention throughout: load 15–20, three runs building concurrently; one 40-minute `lake build` was killed by its own timeout.

## Why I stopped

**Fully complete; task set `done`.** Every clause of the done-criterion is measured, not asserted: non-sorry instance producer ✓, consumers synthesize without the binder ✓, project build passes with the witness included (8744 jobs — the exact number a ground review set as the exit criterion) ✓, foundational axioms only ✓.

A ground review initially said **leave queued**, on one measurable clause: the witness module was unrooted, so the default build excluded the artifact answering the vacuity objection. ajc-truth acted on my rooting request mid-session; I re-measured and the clause is satisfied. Two reviewers and an adversarial refuter failed to break the proof; the refuter's own attempt to refute non-vacuity is what produced the ℙ¹ witness I then landed.

## Next

The frontier moves downstream and is **not** in this cone: nothing consumes the gate, because its headlines quantify over `Scheme.Hom.FiberH1Vanishing`, which has no producer tree-wide — one definition and one eliminator. Ground verified it is the *only* remaining obstruction (curve binders, `IsLocallyTrivial` for `𝒪`, the fibre cover and cover-independence are all producible). The vanishing mathematics already exists in the wrong cohomology model: `RiemannRoch/Adelic/BoundedVanishing.lean` has `subsingleton_h1Mod_iff`/`_peel`/`_of_shift` for `h1Mod` of a Weil divisor, B3 runs on `H1Cok`/`moduleSectionDiff` of an `AffineCoverMVSquare`, and no file mentions both. That bridge (inbox I-0437) is where ajc-rr's lane meets this one, and is the highest-value next item.
