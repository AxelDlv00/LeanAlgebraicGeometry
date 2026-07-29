I have measured all five items. Here is the audit.

## The round's instance of the failure pattern: the stale-copy check fails at two Lean sites

**FINDING 1 — the "74" fix left two live "70"s in `.lean` docstrings. OVERSTATED → the fix is incomplete.**

Commit `3d29922fda` corrected 70 → 74 in the roadmap row, and its message says "the figure has been wrong five times running." It did not touch the Lean source. Two docstrings still publish 70 as the current count:

- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean:856` — "the bulk of what the étale decision still implies: 70 declarations bind the `picSharp`-shaped `HasPicScheme` against 27 on the étale side."
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/IdentityComponent.lean:1481` — "`HasPicScheme` is the right shape over an empty domain, and 70 declarations bind it. New work…"

The second is the worse one: it sits in a paragraph addressed to whoever writes new work, in one of the two files holding the bulk of the 74. This is exactly the documented pattern — the pass that fixes a number leaves its own copies behind. Note the irony that `FGAPicRepresentability.lean:1387` (from `e009c52f96`) names this failure mode explicitly, 531 lines below a live instance of it in the same file.

**FINDING 2 — the roadmap row itself carries both figures. OVERSTATED.**

Within `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJC.picrep.yaml`, the summary says 74 at lines 99-120 and then reverts to 70 at summary lines 122, 132, 136, 173, 180 — including the two paragraphs that carry the row's actual conclusion ("no theorem among the 70 currently speaks about any curve"; "27 vs 70"). A prover reading top-down gets 74; one landing mid-row gets 70. The commit message claims "the conclusion about the 74 is untouched," which is true mathematically but the text does not carry the new number.

## Items measured clean

**ITEM 2 — the 74 count: CONFIRMED, exactly.** I reimplemented the declaration-block method independently (own comment-stripper, own top-level splitter, own signature truncation at first `:=`/`where`, Et counted first) and got 74 with an identical per-file split: Pic0AbelianVariety 34, IdentityComponent 14, FGAPicRepresentability 9, Pic0Dimension 6, GroupSchemeHomogeneity 5, Jacobian 4, HomogeneityOrbitCollapse 2; and 27 Et in the three stated files. The four Jacobian.lean names and lines match (`:406`, `:573`, `:603`, `:700` — the issue says `:701` for the last, off by one).

The sub-claim is **PARTLY OVERSTATED**. `smoothOfRelativeDimension_genus_pic0Et:511` and `isAlbanese_pic0Et:653` do carry neither gate — verified by reading both signatures — and Jacobian.lean's own header at lines 57-58 names them as obligations 4 and 5. But the claim "each has an `Et`-shaped sibling in the SAME file" covers only two of the four. `finrank_tangentSpace_pic0_eq_genus:573` has no Jacobian.lean sibling; its Et counterpart is `finrank_cotangentSpace_eq_genus` in `Picard/Pic0EtTangentSpace.lean:389`, and that one carries an extra hypothesis `(hcomp : SemilinearCotangentComparisonEt C)` the picSharp form does not have. `isAlbanese_pic0_of_isAlgClosed:700` has no Et form at all. So "superseded duplicates" is right for two, and for the other two the supersession is either in a different file with a different hypothesis set or absent. Low misleading risk — the direction of the claim (retained development, not orphaned headline) survives — but the word "each" does not.

**ITEM 3 — the bundling reduction: CONFIRMED, and the caveat is CORRECT.** I wrote my own scratch file and ran `lake env lean`, EXIT=0:

```
'GroundAudit.both_conjuncts_of_picSharp' depends on axioms: [propext, Classical.choice, Quot.sound]
'GroundAudit.control_no_hyp' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
```

Both conjuncts follow from the single picSharp hypothesis via `picSharp_representableBy_picEt_transport` and `isIso_picEtComparison_of_picSharp_representability`, with a control that discriminates. Nothing left over.

On the harder question you flagged: the concern is already resolved in the file, correctly and in the right direction. `not_exists_representing_picSharp_of_not_isIso` (`Picard/PicEtSubcanonical.lean:472`, not `:427` — the anchor in the roadmap row is stale by 45 lines) takes `(hne : ¬ IsIso (picEtComparison C))` as an explicit hypothesis, and that antecedent is unproved in-tree; `PicEtSubcanonical.lean:459-470` says so itself. Your original docstring said "FALSE", which was too strong. It was corrected within the session — the surviving text at `FGAPicRepresentability.lean:608-619` now reads "the honest word … is **unproved with a refutation route mapped out**, not 'FALSE'". So the seam file is right.

But that correction landed in commit `33c2da33e1`, authored by **ajc-p1, not your lane**, and it did not propagate. The bare "FALSE" survives in the roadmap row at summary lines 1, 14, 80 and 132 of `AJC.picrep.yaml` — including the row title line "THE CAMPAIGN'S DESCENT STEP TARGETS A FALSE STATEMENT" and "UNCONDITIONAL representability of picSharp over an arbitrary field is FALSE, not merely open." Line 14 does qualify with "THE ONE UNFORMALISED STEP", so the row is not simply wrong, but the flat absolutes are the sentences a prover will quote.

**ITEM 4 — Pic0.Bundle vacuity: all three CONFIRMED, the third strongly.** My scratch file built `crossInhabit C D` from `(Pic0.bundle D)`'s five projections at type `Pic0.Bundle C` for unrelated curves, EXIT=0, and `(crossInhabit C D).scheme = Scheme.Pic0Scheme D` holds by `rfl` — so `C` is genuinely inert. `Pic0.jacobianScheme C = Scheme.Pic0Scheme C` by `rfl` confirmed with the producer's gates in scope. For the third claim I ran a project-wide comment-stripped census: `Bundle` occurs in exactly two code positions in the entire tree — `AlbaneseUP.lean:343` (the structure) and `:387` (`bundle C`, its only producer). `Pic0.abelJacobi`, `jacobianScheme`, and the Albanese UP all take `C` plus the three geometric instances and route through `jacobianScheme C`, never a bound `Bundle`. Nothing is weakened. The label's framing as a hazard for the next author rather than a live defect is right.

**ITEM 5 — the node deletion: CONFIRMED.** `git show --name-status` gives exactly one path, `D hgraph/nodes/6b703c320821.md`. The file is absent from HEAD and disk. `hasPicScheme_of_etaleSheafified` appears in zero `.lean` files. The only non-transcript references to the node id are `I-1038.yaml` and the `AJC.picrep.yaml` prose that flagged it — both descriptions of the problem, not consumers.

One qualifier on the commit message's reasoning, which claimed the withdrawn Zariski-sheaf citation was "corrected in every .lean and .tex site." That holds for the L1292-L1302 citation specifically — every surviving mention is an explicit retraction. But the unattributed prose form survives at three sites that state it as live fact: `Jacobian.lean:41` ("is not a sheaf even Zariski-locally"), `Jacobian.lean:783`, `PicEtSheaf.lean:150`, plus `blueprint/src/chapters/Picard_FGAPicRepresentability.tex:1058` and `:1106` ("which is not a sheaf"). These do not cite the bad line numbers, so they escaped the citation sweep; they assert the claim the sweep concluded no source supports for the relative functor. Doesn't affect the deletion decision, but the message's absolute is project-scoped to citations rather than to the claim.

## Items 1(b) and 1(c)

**1(b) — the 57 fix: CLEAN.** I re-measured `PicSchemeLocallyOfFiniteType` binders independently: 57, with the per-file split matching the docstring exactly (Pic0AbelianVariety 33, Pic0Dimension 6, IdentityComponent 6, GroupSchemeHomogeneity 5, Jacobian 4, HomogeneityOrbitCollapse 2, FGAPicRepresentability 1). No surviving 61 about that class — the only "61" in the file is the retraction note itself. `PicSharpRepresentable` has 1 binder site, consistent with the new label.

**1(c) — HasStableAffineCover: the correction did NOT propagate; four sites still carry the false absolute.** This is the second-ranked finding. `108c03c17b` and `3c2dde1c02` fixed the roadmap row and the seam file. Still uncorrected:

- `Picard/FiniteGaloisQuotient.lean:61-63` — "**This is no longer a gate: `G2(a)` was discharged** and `StableAffineCover.lean:279` … is a global `instance` deriving it from `[ρ.OrbitsInAffineOpen]` alone." This one is actually fine; it names the hypothesis.
- `Picard/FiniteGaloisQuotient.lean:216-217` — same, names `[OrbitsInAffineOpen]`. Fine.
- `Picard/FiniteGaloisQuotientAffine.lean:52-56` — "**`HasStableAffineCover` is no longer instance-free**" with the orbit hypothesis named. Fine.
- `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJC.picrep.etale-rep.yaml:112` — **"note HasStableAffineCover is NOT a second gate (global instance from [OrbitsInAffineOpen], StableAffineCover.lean:283)"**. The parenthetical names the hypothesis, so the claim is true; but the line anchor is stale — the instance is at `StableAffineCover.lean:282`, and `:283` was the anchor the corrected row was using. Minor.

So the false *absolute* ("unconditional") does not survive; every site names `OrbitsInAffineOpen`. Your correction's conclusion is right and I could not find a surviving copy of the false version. **CONFIRMED clean on the absolute.** Two anchors are stale by 1-4 lines (`:279` in FiniteGaloisQuotient twice, `:283` in the roadmap, against actual `:282`), which is the anchor-rot problem `d3878da73e` was specifically about — and `d3878da73e` re-anchored by name only in `AJC.picrep.yaml`, leaving line anchors in the sibling rows it did not touch.

**1(d) — input 4's absence claim: two stale survivors, and one of them is load-bearing.** The seam file's item 4 was corrected to "LANDED 2026-07-30, this item is CLOSED." The old absence claim survives at:

- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtSubcanonical.lean:87-92` — "**That availability is UNFORMALISED, and this is the one place it is load-bearing** … it is worth stating exactly what backs it: **nothing, yet.** `Scheme.HasRationalPoint C` for a smooth proper geometrically integral `C` over a *separably* closed field has **no producer** in this project — `exact?` fails on it". This is now false: `Curve/SeparablyClosedRationalPoint.lean:333` is `hasRationalPoint_of_isSepClosed`, sorry-free, exactly that statement. And the passage announces itself as the load-bearing site, which is where a prover would go to price the input.
- `Picard/PicEtCrossBase.lean:80` and `:687` — "a section over separably closed fields which has no producer in this project at all (`I-1135`)", twice in one file, the second inside the four-input list.
- `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJC.picrep.etale-rep.yaml:143-155` — "A FOURTH INPUT … the k^s side has no section producer either … That availability is UNFORMALISED." The row does later record the retraction and the `sepclosed-finite` residue, but the header sentence stands uncorrected.

Note these are not your lane's writing at the two `.lean` sites, but the seam correction's own commit message asserts the narrower survivor ("What survives is narrower: G1 consumes the section at a FINITE Galois level") without checking whether the wide version survived elsewhere. It did, at four places.

## Ranked by risk to a prover lane

1. **`PicEtSubcanonical.lean:87-92`** — says "nothing, yet" backs the k^s section at the site it calls load-bearing, when the producer landed. A lane pricing `sepclosed-finite` reads this and budgets the whole k^s half again. This is the one to fix first.
2. **`IdentityComponent.lean:1481`** — publishes 70 to whoever writes new work in a file holding 14 of the 74.
3. **The roadmap row's split personality** — 74 in one paragraph, 70 in five others including both conclusion paragraphs.
4. **`FGAPicRepresentability.lean:856`** — 70, in the seam, 531 lines above your own note about this exact failure mode.
5. **`PicEtCrossBase.lean:80,687`** — the four-input list still prices input 4 as absent.
6. **Bare "FALSE" in `AJC.picrep.yaml`** (lines 1, 14, 80, 132) against the seam file's corrected "unproved with a refutation route mapped out."
7. **Stale anchors** `:279`/`:283` vs actual `:282`; `PicEtSubcanonical.lean:427` vs actual `:472`; `I-1228`'s `:701` vs actual `:700`.

## What I did not measure

I did not run a full `lake build` — my three probes were `lake env lean` on scratch files against existing oleans, all now deleted (`ls AlgebraicJacobian/Ground*` returns nothing; the six pre-existing `GroundProbe*.lean` at the project root are from 2026-07-28 and not mine). I did not audit the blueprint graph beyond the `HasStableAffineCover` and Zariski-sheaf greps, did not verify the "209 other stale nodes" figure in `3dd6a59a56`, and did not check the claim-ledger half of `d3878da73e` (that the four campaign claims have empty owners at HEAD) — `AJC.picrep.etale-rep.galois.yaml` now shows `owner: ajc-p1`, so at least that row was claimed after your read, but I did not check the other three. I filed nothing to the inbox, per read-only scope.
