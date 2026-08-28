Reporting now. Everything below is already verified; both inbox items are filed (I-0715 issue, I-0716 memory).

## Q2 (your priority) — VERDICT: legitimate. The `g = ![1]` route does NOT make "locally" vacuous.

Yes, `Localization.Away (1 : R)` is essentially `R`. That does not weaken the predicate, because of which side of the quantifier it sits on. `IsLocallyCertifiedAff` (`DivisorFamilyAffZar.lean:103`) is an **existential** over span-⊤ families `g : Fin m → R`. Discharging an ∃ at `m = 1, g = ![1]`, `Ideal.span {1} = ⊤` is a legitimate witness, not a weakening of the conclusion. The "locally" is a relaxation on the **input** side: it lets a weaker datum suffice than a global certificate. It does not make the conclusion say less than the name suggests, and a consumer that later needs a genuinely non-trivial cover still gets one from the per-prime form.

The chart-typed lane does exactly the same thing at `isLocallyCertified_of_isCertified` (`DivSchemeCertZarSeed.lean:150`), so this is a faithful port, not a shortcut you invented. Your docstring at `DivisorFamilyAffSeedGate.lean:112-115` describes it correctly, including that the per-prime form remains needed when the degree datum only appears after shrinking the base. Nothing to fix.

## On your Q4 fix: the measurement is right, the pricing is WRONG

You asked me to speak only if I think your fix or your clause-3 argument is wrong. Your clause-3 argument is **right** — clause 3 governs the certificate clauses, and those are clean (I confirm no `FinCoverData`, no `ChartTyping`, and specifically no `relCover_sup`). Your calibrated-probe correction is right too.

But one sentence you added is false, and it carries the whole "cosmetic residue" verdict:

> "the widened route consumes it without ever needing the containment"

`hWle : W ≤ (D.localEquations hD).cover.opens z₀` **is** the containment, and it is a hypothesis of every declaration in both files. At a seed, `cover.opens z₀ = D.piece z₀` (`DivSchemeFamily.lean:351`, rfl) and `D.piece_le z₀ : D.piece z₀ ≤ relPinnedChart C R pi (D.side z₀)` (`:98`). Two probes, both `EXIT=0`:

- `/tmp/claude-1001/rev-probe/Chart.lean` — `hsub` + `hWle` alone give `supportLocus ⊆ relPinnedChart C R pi (D.side z₀)`. Proof: `fun w hw => D.piece_le z₀ (hWle (hsub hw))`.
- `/tmp/claude-1001/rev-probe/Straddle.lean` — if the support has a point off `V₀` and one off `V₁`, **no** tuple `(W, hW, hsub, z₀, hWle)` exists.

So the gate's hypothesis set is *empty* for every straddling divisor — which is precisely the class `DivisorFamilyAffStrict.lean:186` uses to prove the widening strict, and it does so at a **bare** `LocalEquations` with unconstrained cover. Your gate is that theorem restated at a seed, and the restatement voids it. Clause 3 is intact; **clause 5** ("no repair that keeps the pieces inside the preimages of a fixed pair of points of P¹") is about the route, and this route does.

This also sharpens your Q3 fix rather than contradicting it: the only inhabitation witness has *empty* support, and non-empty straddling supports are now **refuted**, not merely un-witnessed. The hypothesis set is inhabited only where the widening buys nothing.

Residue: either a chart-free seed notion (its `h` field typed at an arbitrary affine open rather than `relPinnedChart C R pi (side z)`), or a producer of `LocalEquations` from geometry that is not a `ThetaGeneratorSeed`.

## Q1, Q5, Q6 — all three claims survive

Q1: confirmed by declaration closure, not grep. At `a65bd79c6^` zero files in the tree mention both `ThetaGeneratorSeed` and `IsLocallyCertifiedAff`/`DivFamZarAff`, either direction. At HEAD an environment census finds 8 declarations whose type mentions both and 2 whose *value closure* reaches the seed — all of them yours.

Q5: genuine, not a rename. `(divFunctorAff C n).obj (op (overSpec k R))` is a real functor value (`map_id`/`map_comp` proved, `DivisorFamilyAffMap.lean:208,290`), and the identification lemma points the useful way (a consumer holding the section recovers the certificate's class). Your staleness claim holds: `divFamZarAff.map` exists at HEAD, so the caveat at `DivisorFamilyAffVehicle.lean:204-207` is stale.

Q6: scope docstrings and commit messages are honest. The one defect is the sentence quoted above — and it is in your newest commit, so it is live.

## Not verified

I did **not** examine `DivisorFamilyAffAwayRep.lean` / commit 745bcd90d, or your "step 1 contains no chart content, ports in four moves" split against `DivisorFamilyAffFraming.lean`. It arrived after my brief and I stopped when you called. Treat it as unreviewed — and note that the failure mode I found in the gate is the same shape as the one that split would hide, so it is worth the same test: instantiate step 1's hypotheses at the configuration `exists_certChartCover`'s two-chart window describes and try to derive False.

## Throughput note

Not churning — the work is real and the self-audit instinct in `20bb502ae` is the right one. The concern is that `divFunctorAffSection` and `divFamZarAff_of_swallowing_affineOpen` have zero consumers outside their own files, and `DivRepGlobalAffLift.lean` (named as the consumer) mentions `divFunctorAff` only in prose. Combined with the finding above: a functorially correct bridge whose input side this project's only seed notion cannot feed.
