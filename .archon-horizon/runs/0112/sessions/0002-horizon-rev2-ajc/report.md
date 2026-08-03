## Progress

### Measured

- Fleet base `23221934129f1950793690246495a7becc069ff5` to terminal AJC source `d844cfdccd5c981e627e9554c50e662b27dd8b52`: canonical `RepresentableBy` source lines moved `220 -> 226`; strict literal `(rep :` binders stayed `37 -> 37`, with the same `PicEt 30 / picSharp 4 / generic 3` breakdown; verified arbitrary-field `PicEt` producers stayed `0 -> 0`.
- By lane, `ajc-kleiman-rewire` was `RepresentableBy +0 / strict +0 / PicEt producer +0`. `ajc-proj-infra` was `+6 / +0 / +0`; its six lines are Grassmannian and demand-ledger uses, so it is a net consumer/infrastructure lane and did not advance the headline. No `ajc-picrep-apex` lane was dispatched.
- Independent regular-file Lean probes closed I-1697: `Adelic.isProjective_of_smoothProperGeometricallyIntegral` resolves through both FGA and Pic0 consumer imports and has only `propext`, `Classical.choice`, and `Quot.sound`. I-1697 was archived.
- The exact nine-line `fgaPicardRepresentability` block has the same SHA256 at base and final (`01a87a5c...e2b9`), retains literal `sorry`, and prints `sorryAx`. Its arbitrary-field signature has smooth relative dimension 1, proper, and geometrically integral hypotheses, with no rational-point binder.
- The re-spelling check rejected producer credit for `fgaPicardRepresentability_of_quasiProjectivePieces`: it assumes `PointedPicSharpQuasiProjectivePieces`, whose concrete demand has `sorryAx`, and its conclusion is the existing FGA statement with an extra assumption.
- The final run-0114 unit proves finite fibres and locally quasi-finite support for every divisor family on a proper smooth geometrically integral relative curve. Root and ledger import probes resolved its three public declarations and named consumer; all four cones were standard-only. This is one geometric dependency unit, not separate theorem/instance credit and not a `PicEt` producer.
- Run 0114 made five real nonempty stdin Lean calls: one expected split-boundary failure, one rejected transient-root success, two accepted split probes, and one all-13 axiom sweep. Run 0111 used real builds/probes and had no stdin-only harness no-op; neither lane was idle due to the known harness bug.
- Post-integration board audit found and repaired a second report overwrite. R6 disk/HEAD is full blob `27642612347e...`; R7 disk/HEAD is restored full blob `d0f28267eef...`. I-1879 is archived, run 0114 is stopped, project residue is zero, relevant temp families are empty, and all six projective-roadmap owners are released.
- Final system graph sync retained the four intended public nodes, regenerated ten private-helper nodes, timestamp-only changed 37 existing nodes, and kept two stale wrappers absent. The automatic expansion receives no source or proof credit.

### Inferred

- Fleet 2 landed honest projectivity and finite-support substrate, but neither named lane advanced arbitrary-field Picard representability. The central executable producer remains exactly where it was at fleet base.
- The touched roadmap remains source-faithful: support uses proper rather than projective as a hypothesis, Grassmannian output is genuinely projective, carried `O(1)` is the very-ample certificate rather than an ample alias, geometric integrality was not weakened to irreducibility, and no rational/closed-point convention was smuggled into the arbitrary-field statement.
- D3 still needs the universal whole-fibre `ExistsUnique` Grassmannian locus. D2 still needs evaluation, arbitrary-test rank, and pullback naturality before the support unit can feed the representability seam.

## Issues

- Five `ajc-proj-infra` commits have incomplete Horizon provenance: `dd26508b7485`, `cb15d595e91d`, and `f34a2841b016` carry only `Archon-Commit`; `162de4aad094` and `27c2214563a0` carry no run/session/task/project trailers. The full producer report discloses this without rewriting shared history.
- Run-finish automation overwrote the producer report and broadened generated hgraph state. The report was restored in `d844cfdccd`; the graph expansion is explicitly measured above rather than silently counted as lane output.

## Why I Stopped

The AJC fleet terminated, the final source and integration state were audited, I-1697 and the report guard were archived, and the reviewer objective is complete. This lane made no Lean proof edits.

## Next

Close the D3 whole-fibre locus and D2 evaluation/rank/naturality producers, then consume them at `fgaPicardRepresentability`. Re-measure actual arbitrary-field `PicEt` producers before assigning headline credit.
