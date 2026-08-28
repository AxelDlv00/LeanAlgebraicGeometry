The checkpoint is satisfied: all six paths I authored or repaired are committed and byte-identical at HEAD. The 164 dirty paths are other lanes' live work — `Pic0ChartAbelForkReduce.lean` belongs to ajcr-p2 (commit `4fb9d5e9c3`), and the ~163 `hgraph/nodes/*.md` files are graph-sync churn I never wrote. Staging any of them would repeat exactly the shared-index accident I spent this session repairing, so I am deliberately leaving them.

My file-mutating calls after the last commit were verification-only: the citation and axiom probes under `scratch_p3/`, which I removed (`ls` confirms no `scratch_p3`), plus the two memory files outside the ledger. Neither produced durable workspace changes.

## Progress

- `Picard/DivisorFamilyAffAbel.lean` (new, rooted at `AlgebraicJacobian.lean:627`): 10 declarations, sorry-free, all axiom-clean `[propext, Classical.choice, Quot.sound]` against a control that fired `sorryAx`. The widened carrier now reaches `picEt`.
- `Picard/DivisorFamilyAffFieldDegree.lean` (new, rooted): 4 declarations, sorry-free, axiom-clean vs a firing control — the algebraic third of the named residue, executed rather than predicted.
- `AlgebraicJacobian.lean`: both rooted, so the axiom probe sees them. Full root build EXIT=0, 9311 jobs.
- Restored three of ajc-p2's AJC files that my own commits reverted (`ff68af0372`), verified same-hash by both lanes.

**Claimed and released** `AJCR.w4-rep.datum.dat-d.ddr.divrep.abel-widened` (I-1054 → I-1107, owner cleared, pinned). It was third-most important because `DivFamZarAff` — the carrier human protection I-0492 mandates — had a Picard class, a functor and a comparison but zero declarations reaching `PicEtAff`/`picEt`/`relPic`/`pic0`, while the atlas producer `abelSigmaChart` binds the chart-typed functor. A missing arrow between two individually-complete layers, invisible to every per-declaration sweep we run.

**State: advanced, not closed.** `rep` undischarged, no gate cleared. One named obligation remains, `hdegAff`, carried explicitly in the signature and inhabited by `degAt_abelDivAff'_toAff` through an external theorem rather than by projecting a binder.

## Issues

- **My central pricing was wrong; retracted in file, row and release note.** I called the widened degree ledger *obstructed* because the cited step names `relCover_sup`/`cover₀`/`cover₁`. That step *outputs* only "every point lies in some piece", which the widened side carries as the field `AffCoverData.cover` — the widening is cheaper there. I re-derived the refutation before accepting it, then executed the algebraic third of the port and not one proof step changed.
- Two prose corrections: `rep` is not an antecedent of `pic0RepresentableByOfCharts`, and π is a section variable nowhere in my file. `degAt_abelDivAff'_toAff` weakened to `[IsAffineHom π]`.
- **I reverted another lane's committed work twice** via the shared index, despite explicit single-path staging (I-1070/I-1082). Repaired and verified; my own guess at the cause was unsupported and I withdrew it.

## Next

Port the two remaining presentation-divisor lemmas, `finrank_colength_eq_sum` (`DivisorFamilyFieldDegree.lean:217`) and `coeffAt_eq_zero_of_isUnit_germ` (`:282`), to `AffAdaptation`. They carry the geometric side, so unlike the algebraic half they may not transcribe verbatim. Dropping `hdegAff` yields a widened `chartValueTrans` and hence a widened Σ-chart.
