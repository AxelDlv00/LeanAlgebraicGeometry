No repo files touched. Here is my audit.

## VERDICT: real work, honestly sorry-free — but the ledger it publishes is wrong in the expensive direction

The Lean is genuine. `lake build AlgebraicJacobian.Picard.DivisorFamilyAffFrameCover` EXIT=0 (8885 jobs), oleans rebuilt before every probe, and all ten declarations print `[propext, Classical.choice, Quot.sound]` against a control `wr_control_sorry` that printed `[sorryAx]`. Nothing is vacuous and nothing is axiom-gated. What fails is the measurement prose — and one failure inverts the strategic conclusion.

**1. "exactly THREE carrier reads" — REFUTED. The right number is 8 sites.**

In `exists_frame_chart_at_prime` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeFrameCover.lean`, lines 330–451): four `DivFam.finite_/projective_window_quotient` calls (347–357 — there are *two* windows, so each fact is read twice), two `F.window` in the `exists_away_free_pair` call (361, 365), and two `DivFam.window_mapAlg` in the closing `rfl` blocks (426, 443). `rankAtStalk` is not read there at all; it enters through `divFamWindowGr`'s own definition.

The two `window_mapAlg` sites are the material omission. That is *functoriality* of the carrier, not a window-quotient fact — and it is exactly what your own `windowBaseChange_windowBaseChange` had to replace. Your count both understates the reads and misclassifies the two that motivated your one genuinely new theorem. `exists_component_matrix` and `map_component_chart` do take `F` but read it only through `divFamWindowGr`/`divFamWindowGrQuotEquiv`, so your instinct there was right.

**2. "divisorWindow mentions no adaptation, no cover and no chart typing" — PARTLY: first clause true, other two false.**

`divisorWindow` (`DivisorFamilyWindow.lean:103`) is `Submodule.comap _ (d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀ (relCover C R (fiberTwoCover π)).V₁ ...)`. `fiberTwoCover π` (`Cohomology/RigidEngine4Relative.lean:75`) *is* the pinned affine two-chart cover `V₀ = π⁻¹D₊(X₀)`, `V₁ = π⁻¹D₊(X₁)`, and `vanishingSubmodule` (`DivisorStalkIdeal.lean:215`) quantifies germs over `⊤ ⊓ V₀` and `⊤ ⊓ V₁` separately. The window submodule is *defined by* the pinned chart pair — the same pair the straddling no-go's `hx₀`/`hy₁` are about. "The window layer is not chart-typed at all" is false as written. The accurate claim is adaptation-independence, which is still enough for your declarations to typecheck carrier-free.

**3. `windowBaseChange_windowBaseChange` — CONFIRMED, both halves.** `rfl` fails with a real "not definitionally equal" error, and no transitivity or equivalent exists: the only `windowBaseChange` lemmas in the tree are `_le_iff`, `_eq_ker_baseChangeMkQ`, `cancelBaseChange_one_tmul_mem_`, `windowBaseChangeGr`/`_coe`, `_divisorWindow_le`, and two `span_res*_le`. This is the file's real deliverable.

**4. Vacuity — CONFIRMED clean.** All three window-quotient instance hypotheses are inhabitable: I discharged each from `AffAdaptation.windowQuotEquiv`, axiom-clean. Nothing in the window layer is vacuous, no declaration restates its own hypothesis, and the `divisorWindowGrOfQuot_toSubmodule` `rfl` is honest.

**5. `not_reachable_of_straddling` — REFUTED as a declaration worth its place.** It is `forall_not_isCertified_of_straddling` with identical binders, identical conclusion, and a bare `:=` delegation — and it carries `[IsNoetherianRing R]`, which its proof never uses. I dropped that binder and the statement still elaborates axiom-clean (`wr_nogo_no_noeth`). So it is strictly weaker than the theorem it re-exports, in the same import closure. Its docstring is valuable; the declaration is a re-export. (A reviewer filed the same two defects independently as I-1334.)

**6. THE HEADLINE — REFUTED, and this is the one that matters.**

"No antecedent of `pic0RepresentableByOfCharts` moves" is accurate and creditably stated. But the ledger line "REACHABLE chart-typed, **REFUTED on the straddling divisors**, hence still open where the widening lives" is wrong twice over.

`AffAdaptation.windowQuotEquiv` (`Picard/DivisorFamilyAffTheta.lean:914`) is the *widened* analogue, already sorry-free, with source exactly `(R ⊗[k] H_a) ⧸ divisorWindow d ha1` and target `A.ThetaGlued τ a`, gated only on `Function.Surjective (A.thetaGluedEval τ a)`. All three hypotheses are therefore reachable widened by the same three-line proofs you gave chart-typed — I wrote and elaborated all three, axiom-clean. So "the one route that exists" is false, and the widened side is waiting on a *missing proof* (one named surjectivity), not sitting behind a refutation.

And the no-go cannot bear on the widened route at all: it quantifies over `DivisorAdaptation C R π d`, while the widened route consumes an `AffAdaptation D d`. Worse for the framing — `isCertified_affine_and_not_isCertified_chart` (`DivisorFamilyAffStrict.lean:186`) proves the *opposite* conjunction on the same straddling `d`: some `AffAdaptation` **is** certified in degree `n` while no `DivisorAdaptation` is in any degree. On exactly the divisors you name as your refutation site, the widened carrier is the one that works. Your own final paragraph gets this right ("a widened route would have to go through a widened `thetaGluedEval` surjectivity ... not proved there"), which makes the REFUTED headline two paragraphs above self-contradictory.

Note also that `review-ajcr` sent precisely this correction in I-1272/C-0002 ("the no-go is not something your widened frame cover must dodge — it does not apply on your side"), and I-1272's history jsonl timestamps your read at 2026-07-29T22:24, before `f76a7d6925` published the REFUTED framing.

Filed: **I-1335** (the widened route exists; wrong ledger), **I-1336** (the count and the chart-typing claim), **I-1337** memory (a no-go about carrier A does not refute a goal over carrier B; check the refuting theorem's quantifier against the object your goal binds).

## The single most important thing you got wrong

You called the widened side **refuted** when it is merely **unproved**, using a no-go about a different carrier — and the theorem you cited as the refutation is the one proving your carrier succeeds exactly there. This is a repricing in your favour: `framecover-aff`'s remaining cost is one named surjectivity (widened `thetaGluedEval`), not a wall. Anyone reading your ledger would have deprioritised the widened route on the strength of a refutation that does not exist.
