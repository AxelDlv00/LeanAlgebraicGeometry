All boundary maintenance done. The task stays without a terminal status — two of four fronts remain open, so it returns to the queue.

## Summary

Closed **two** of the four fronts of the A.3 leg, plus a generator obligation that had been open in *both* projects — and in each case what unblocked it was a measurement, not a new proof technique. Root build green at **8810 jobs, exit 0, zero errors**; all six new declarations axiom-clean measured against the full 252-module root with two controls correctly reporting `sorryAx`.

The through-line: three of my six commits correct false claims made by this lane in earlier sessions. The single most expensive error was recording "downstream" as a property of a *theorem* when it is a property of a *file*.

## Progress

- `RiemannRoch/WeilDivisor.lean`: **1 sorry → 0. AJC.rr.principal CLOSED** (roadmap `done`, pinned `8b654f78d`). `principal_degree_zero` proved at its *original* binders via the ported χ-ledger, with all three carrier comparisons discharged rather than assumed. The "import inversion" that walled it for three sessions was never real — I had measured the cone of the file that *proves* the statement (`Ledger/PrincipalTransport`, 51 files, genuinely inverted) and never the cones of its *inputs* (7 / 37 / 4 files, all WeilDivisor-free; union 42; zero cycles). Hartshorne's case split is deleted: the chain is uniform in `f`, so the two geometric sub-lemmas the docstring owed for months are not owed.
- `Picard/IdentityComponent.lean`: **3 → 2.** `PicScheme.degree` has a body. My own r1 verdict — "a statement bug; no total function of that type is constructible" — was wrong: the premise constrains which values are *pinned*, not totality, and `fun _ => 0` refutes it in one line. It now splits on the section condition and equals `degreeOfSectionPinned` there.
- `Picard/DualNumberChartTriviality.lean`: 3 new declarations. The generator `m` that AJC and AJCR each *assumed* is cyclicity of `M ⧸ (ε)M` written without naming the quotient. Converse included, so it is a strict reduction.
- `Picard/Pic0AbelianVariety.lean`: **untouched, 3 sorries.** Fronts (a) and (b) did not move.
- `.gitignore`: the probe-ignore pattern was case-sensitive (`*Probe*` only), so three of my lowercase probes reached HEAD via another lane's integration commit — the exact phantom-deletion hazard that file's own comment predicts.

## Issues

- **The review found the fourth overclaim where I asked it to look — in the file I had just closed.** `WeilDivisor.lean`'s section header still said the coheight bound "lives downstream of this file" while the proof 1100 lines below *calls* it. The file asserted and refuted the same claim. Fixed at `7a481303c`.
- **`ClassDegreePinned`'s non-vacuity is conditional on a `DivFamily` producer that does not exist anywhere in AJC.** The docstring says so, but the honest reading is that my new binder cost nothing because nothing yet depends on it.
- `hgit commit` **hung** (not failed) four times under eight-lane contention; a git plumbing compare-and-swap landed in ~5s and is strictly safer. Two silent-write defects found: `roadmap set --summary` dropped a 3.4 kB update while exiting 0, and I verified comments against the wrong file for four wasted retries.
- Both earlier subagents delivered; the reviewer stalled and needed an explicit "report now" prompt. Fifth occurrence in this lane.

## Why I stopped

Partly advanced, not complete — no terminal status set, so the task returns to the queue. Front (a)'s cocycle map and front (b)'s two residues (reducedness over k̄, valuative existence) are untouched and are genuine mathematics, not artefacts.

## Next

1. **Front (b) is the cheapest remaining win** and has *two* independent reductions already in the tree — try `universallyClosed_of_ambient` (properness of `Pic⁰` from universal closedness of the ambient `Pic`, where Kleiman's theorem actually speaks) before the valuative route.
2. **Front (a)'s clause (iii)** needs the sheaf-side "glue a line bundle from a transition unit" comparison against AJC's `OnProduct` setoid. AJCR's version is welded to `X.CechPic`, which AJC does not have; mathlib has no Picard group of a scheme at all.
3. Within chart triviality, what remains is freeness of the **restriction** — not the generator.
4. `AJC.picrep.tensor` is real open work under a `done` parent; I filed it as I-0640 for a human route call rather than guessing.
