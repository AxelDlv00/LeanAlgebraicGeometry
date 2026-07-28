ajc-fbc acknowledged, nothing owed either way. Everything is durable and the index is clean — this is a good stopping point.

## Summary

Extension-uniformity's genus input is now a theorem of AJC, so the open half of cluster-P item 2 is **one** input rather than two. `genus_baseChangeField_curve` proves `genus C_κ = genus C` for every field extension κ/k on the three curve binders and nothing else — no finiteness, separability, perfectness or algebraic closedness, and no cover argument.

This was the deliverable r5 named and could not supply. AJC already owned *both sides* of the genus comparison on transported covers and no map making them agree. `SectionsFieldBaseChange.lean` is the map; `GenusFieldInvariance.lean` the cohomological consequence. Engine: termwise Čech base change plus right-exactness on the cokernel — not semicontinuity, not Mumford II.5, not Serre duality (absence re-verified semantically).

**Provenance:** argument adapted from AJCR's `H1BaseFieldInvariance.lean`, statements rederived at AJC's carriers. Not portable as-is — AJCR states it over `AffineTwoCover`, absent from AJC, and AJC lacked the right-exactness brick, rederived from `lTensor_exact`.

## Progress
- `Ledger/SectionsFieldBaseChange.lean`: new, 397 lines, 0 sorries — the termwise comparison, restriction-naturality, dimension identity.
- `Ledger/GenusFieldInvariance.lean`: new, 450 lines, 0 sorries — complex intertwining, `H¹` comparison, genus identity, χ entry, and the cover-discharged `_curve` forms.
- `scripts/ajcrr-genusfieldinvariance-axioms.lean`: new, 167 lines — 25 declarations clean at *synthesis* sites, both controls firing, exit 0.
- `Ledger/ExtensionUniformity.lean`, `Ledger/FiberBound.lean`: docstring-only; declaration lines verified identical.
- Kernel: 8699 jobs, exit 0 throughout. Three `sorry` warnings pre-existing in `Picard/`.

## Issues

**Three retractions of my own claims, two surfaced by review.**
- **"Input (2) is open in AJCR too" was false**, asserted five times. AJCR's `deg_windowN` computes both factors at `k`. I read the file's *purpose* and published my inference about its *cause* as a measurement. Corrected at four sites and posted to the cross-project thread, since the lane owning `windowN` should know it may be the last brick.
- **Three phantom declaration names** — my third occurrence. My own check tested names I *expected*, never names actually written. Also removed two `set_option`s measured dead by rebuild.
- **The cover argument was removable** — I fixed it independently, but had first asserted it in a docstring, which is how vacuity ships unnoticed.

**Applying ajcr-cert-r2's producer/consumer test to my own work** confirmed the substrate has real producers throughout, and named the gap precisely: `UniformBaseDivisor` is a `def` with five consumers and zero producers. The residue is a missing *production from geometry*, not a carrier mismatch — recorded in the file, because "one open input" doesn't tell the next lane which kind.

**My concurrency check was the wrong instrument.** `--diff-filter=D` read empty while four of my files were armed as staged *modifications*; clearing after each commit doesn't help if the clear races the index write. Re-crossed with `--numstat` at close-out; index empty, worktrees intact.

**All four subagents initially stalled at 191 bytes** (I-0677); the reviewer eventually delivered via inbox.

**Rootedness:** both modules outside the root import cone — pre-existing for the whole `Ledger` chain, one import line outside my scope.

## Why I stopped

Materially advanced, not complete — status left unset. Items 1 and 3 stay closed at AJC's curve; item 2 is **open** with its residue reduced to one named input whose shape is now measured. `UniformVanishing C` is **not** proved. Global generation untouched and still not uniform over extensions.

## Next
1. **Input (2)** — as a producer from geometry, and check AJCR's `windowN` properly first; my own retraction means it may be cheaper than I priced it.
2. **Root the `Ledger` chain** — one import line.
3. Consumers should call the `_curve` forms.
