# Algebraic Jacobian Challenge

A Lean 4 formalization of the Jacobian of a smooth, proper, geometrically
irreducible curve over a field.  The project takes the Picard-scheme route: build
the relative Picard functor, represent it, identify its identity component as an
abelian variety of dimension the genus, and derive the Albanese universal
property.  The first and last legs are substantially built; representability is
the open frontier.

Representability is being built by the **Milne–Kollár route** — construct
`Pic^r` over a separably closed field from the loci where `h⁰ = 1`, glue,
descend to `k` by a finite Galois quotient, assemble the degrees by a coproduct.
The plan of record is [`informal/pic-representability-campaign.md`](informal/pic-representability-campaign.md).
The Grothendieck/Kleiman quotient route via the Quot scheme is **not** the path
being built: its descent step needs a quasi-projectivity hypothesis that is not
expressible at the pinned Mathlib revision and without which the lemma is false.
Its substrate (Grassmannians, graded algebra, flattening stratification) is
sorry-free and is consumed by the committed route, so it is retained.

Two of the committed route's own engines are substantially built.  The rigidified
pushforward gate is **discharged**: `Adelic.instHasRigidPushforwardOfCurve` is a real
instance for every curve satisfying the challenge hypotheses, and it measures axiom-clean
at the synthesis site, as do the three extraction theorems that now synthesise it rather
than assuming it.  The finite Galois
quotient has Speiser descent, the affine quotient, and `Γ`-stable affine covers proved;
what remains there is gluing.  Both are stated with proofs and Lean pins in the
blueprint's FGA chapter, §"The Milne–Kollár route".  Neither route is hypothesis-free:
the quotient route needs quasi-projectivity of the Abel-map slice, the committed route
needs every finite Galois orbit to lie in an affine open, and the same Hironaka example
defeats both if its hypothesis is dropped.  The difference is that the orbit condition is
available for the schemes this route quotients.

It is developed alongside `Algebraic-Jacobian-Challenge-Rebuild`, which attacks the
same theorem by a separate curve-specialized strategy.

## State (measured 2026-07-28)

- **273 modules, 158,653 lines** (re-measured 2026-07-29 02:55, up from 264/155,729 two
  hours earlier); a warm `lake build AlgebraicJacobian` was **green** at 8,746 jobs when last
  measured, which was before the 2026-07-28 lanes landed.  The `sorry` count is deliberately
  not restated here: it was 28 over 11 modules at the earlier measurement and four AJC lanes
  have landed work since.  These counts move whenever a module lands, so re-measure rather
  than quoting them:

  ```bash
  find AlgebraicJacobian -name '*.lean' | wc -l          # modules on disk
  find AlgebraicJacobian -name '*.lean' -exec cat {} + | wc -l
  lake build AlgebraicJacobian 2>&1 | grep -c 'declaration uses .sorry'
  ```
- **Rootedness is worth measuring, not assuming.**  A module that nothing imports
  compiles green and is invisible *both* to the root build and to the axiom probe,
  with nothing warning about it — `import AlgebraicJacobian` never reaches it, so no
  `#print axioms` line for it can even be written.  The check is the second
  measurement in [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean)'s
  header.  Modules land here from several parallel efforts, so the unrooted set is
  routinely non-empty for a short while: a module not yet committed to the workspace
  ledger must **not** be rooted, since a clean checkout would then fail to build.  That
  grace period ends at the commit — once a module is in the ledger, leaving it unrooted
  means the build does not check it.  **Currently violated in 17 modules** (measured
  2026-07-29 02:55 by walking `import AlgebraicJacobian` from the root module: 257 of 274
  modules — the 273 under `AlgebraicJacobian/` plus the root aggregator — in the root cone,
  17 outside it).  All 17 are committed to the ledger, so none is inside the grace period:
  - `RiemannRoch/Ledger/{DegreeVanishing,GenusBridge,NonVacuity,PrincipalCompare,`
    `PrincipalTransport,SectionDrop}` and `RiemannRoch/LedgerPortability` — 37 of the 51
    `Ledger/` files are in the cone via `RiemannRoch/WeilDivisor.lean` (commit
    `8b654f78d`); these are not.  Tracked as inbox issue `I-0600`.
  - `RiemannRoch/Ledger/{FiberChart,FiberDivisor,FiberLattice,FiberVanishing,FiberBound,`
    `QcohSections,AffineVanishingQcoh,DivisorSheafQcoh}` — the fibrewise large-twist
    vanishing layer ported from the sibling project (run 0074 r4, task `ajc-rr`), which
    makes the cluster-P statements unconditional at this project's own curve.  Landed
    unrooted because the root roll-up is outside that lane's write scope; same `I-0600`.
  - `Picard/{Pic0Dimension,SchemeKrullDimStalk}`.

  The four `Albanese/SymPow*` modules that this bullet used to list were rooted by run 0069
  r5 and are no longer in the set.

  Their declarations are not elaborated by `lake build AlgebraicJacobian` and no
  `#print axioms` line through the root can reach them.  Re-measure with the
  reachability snippet in [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean)'s
  header (seed it at `AlgebraicJacobian`, not `AlgebraicJacobian.Jacobian`) rather than
  quoting these counts; tracked as inbox issue `I-0600`.
- **Locally sorry-free is not axiom-clean.**  The synthesis-leak surface is now a single
  instance: `instHasPicSchemeEt` (`Picard/FGAPicRepresentability.lean`), whose body cites
  the one named `sorry` `fgaPicardRepresentability`, so every site that *synthesises*
  `HasPicSchemeEt` acquires `sorryAx`.  (`instHasPicScheme` no longer exists; its
  successor `picSchemeOfHasRationalPoint` is a named theorem, and
  `pullback_preservesFiniteLimits` is deliberately **not** an instance — the `sorry`
  there sits in the named theorem `pullback_preservesMonomorphisms`.)  A theorem that
  merely *quantifies over* such a gate reports clean axioms, because the hypothesis is
  discharged by the caller; the leak appears at any call site that must
  synthesise the instance.  Run
  [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean) (`lake env lean
  scripts/axiom-frontier.lean`, 147 declarations: 95 clean and 52 carrying `sorryAx`,
  measured 2026-07-28 with `lake build AlgebraicJacobian.Jacobian` green at 8,657
  jobs) before believing any
  completeness claim — it measures the frontier rather than inferring it.  Count by
  output *entry*, not by output line:
  Lean wraps a long axiom list across several lines, so a per-line filter
  misclassifies exactly the declarations with the longest lists.  The header carries
  the recipe.
- **A clean axiom set answers one question only:** is a `sorry` reachable from this
  proof term.  It says nothing about unproved, false, refutable, un-instantiable or
  conclusion-equivalent hypotheses carried in the *statement*, nor about a module the
  probe never reaches.  Every such mode found in this tree is catalogued, with the
  declaration it was measured on and the check that finds it, in inbox memory `I-0442`
  (keyed to the probe's section headers).  Read the probe's section headers, not just its
  output lines.
- **Every `sorry` carrier in the tree is now a named theorem or definition**, which is why
  the synthesis-leak surface reduces to the one instance above (an instance is the only
  carrier a consumer can reach without naming it).  The probe's §2 lists the carriers by
  module; note that two of them hold their `sorry` in a *field*, which a grep for
  `:= sorry` misses.  Re-derive rather than trust the number:

  ```bash
  lake build AlgebraicJacobian 2>&1 | grep 'declaration uses' | sort -u
  ```
- 81 modules still open with a bare `import Mathlib`; this is the
  dominant build cost and is being converted bottom-up with the helpers in
  `scripts/`.

## Decision made: the headline is stated over an arbitrary field

**Settled 2026-07-28 by the project owner** (roadmap `AJC.picrep.rational-point`,
inbox `I-0372`, protection `I-0491`).  The Jacobian headline is stated over an
**arbitrary** base field with **no** rational-point hypothesis, and what gets
represented is the **étale-sheafified** relative Picard functor.  This is Kleiman's
own formulation and the full strength the challenge asks for.  It is not a branch to
revisit.

What that means concretely, and each piece is checkable:

- `Picard/PicEtSheaf.lean` builds the étale-sheafified relative Picard functor
  `Pic_{(C/k)ét}` and **proves its sheaf property** (`picEt_isSheaf_forget`) — it is
  a sheafification, so the axiom holds by construction rather than by hypothesis.  The
  étale site is Mathlib v4.31's `Scheme.etaleTopology` localised at `Spec k` along
  SGA 4 III 5.2.1.  The file is `sorry`-free.
- `Scheme.fgaPicardRepresentability` (`Picard/FGAPicRepresentability.lean`) is the
  representability obligation, restated for that functor with no rational point.  It
  is **one named `sorry`** and is the project's central open obligation; it is
  expected to stay open, and that is the honest state rather than a defect.
- `hasRationalPoint_of_curve` has been **deleted**.  It asserted a `k`-rational point
  from the challenge hypotheses alone, which is *false* — a conic over `ℚ` without
  rational points, or a genus-2 curve over `ℚ` without one, satisfies every other
  hypothesis.  While it existed the witness rested on an inconsistent hypothesis, so
  its consequences were vacuously true and no axiom check could tell.  It must never
  be proved or reinstated.
- `picardJacobianWitness` now carries exactly the three challenge hypotheses
  (`SmoothOfRelativeDimension 1`, `IsProper`, `GeometricallyIrreducible`) and nothing
  else.  This is checked, not asserted: `scripts/axiom-frontier.lean` has a
  `HeadlineBinders` section whose `example`s stop elaborating if a
  `[HasRationalPoint _]` binder ever returns to the headline cone.

**The obligation count is unchanged at five, and that is the deliverable.**  The
witness rests on `fgaPicardRepresentability`, `Pic0Et.geometricallyReduced`,
`Pic0Et.universallyClosed`, `smoothOfRelativeDimension_genus_pic0Et` and
`isAlbanese_pic0Et`.  (Not `Pic0Et.smooth` / `Pic0Et.proper`: those are *assemblies*
over the middle two, so citing them as the open statements is a stale reading.)  What changed is not
the number but the *kind*: **none of the five is a false statement any more**.  All
five are true statements awaiting proofs.  That difference is invisible to
`#print axioms` — it is a property of the statements, not of the proof terms — which
is why it is argued at the binders instead.

Two things are kept beside the headline and **neither may be presented as it**:
`picardJacobianWitnessOfHasRationalPoint`, an explicitly *conditional* milestone
(true under a section, strictly weaker than the challenge), and
`picardJacobianWitnessOfIsAlgClosed`, a genuine theorem over `k̄`.  The
`picSharp`-shaped gate `HasPicScheme` survives for the consumers written against it,
but it is **no longer an instance**: its only producer is the named theorem
`picSchemeOfHasRationalPoint`, so nothing picks up a rational-point hypothesis by
synthesis.

The route choice is unaffected: Milne–Kollár stays committed, Quot stays
retained-not-revived.


Cones closed: `AJC.substrate`, `AJC.linebundle`, `AJC.grquot`, `AJC.cech`.
Cones open: `AJC.fbc` (flat base change; one walled naturality leaf plus one
bypassed monument, run 0068 r3), `AJC.rr`, `AJC.picrep`
(Picard representability), `AJC.pic0av` (Pic⁰ is an abelian variety),
`AJC.albanese`.  Run `horizon roadmap list --focus AJC.jacobian` for the live tree
— the roadmap, not this file, is the authority on status.

## Navigation

- [`AlgebraicJacobian.lean`](AlgebraicJacobian.lean): project import root.
- [`AlgebraicJacobian/Jacobian.lean`](AlgebraicJacobian/Jacobian.lean): the final
  Jacobian witness interface and assembly point.  The witness is built from
  `Pic⁰_{C/k}` in its étale form (`Picard/Pic0Et.lean`) and carries **no**
  rational-point hypothesis.  It depends on the same five obligations listed above:
  `fgaPicardRepresentability` (the representability of `Pic_{(C/k)ét}`),
  `Pic0Et.geometricallyReduced` and `Pic0Et.universallyClosed` upstream, plus the two leaves
  `smoothOfRelativeDimension_genus_pic0Et` and `isAlbanese_pic0Et` stated there.  All
  five are **true** statements awaiting proofs.  The two leaves carry *companions*
  stating what the landed development already reaches
  (`finrank_tangentSpace_pic0_eq_genus`, `isAlbanese_pic0_of_isAlgClosed`), so each
  leaf's remaining distance is compiler-checked rather than described in prose; both
  companions record a distance and carry `sorryAx`, and the probe's §0 says why.
- [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean): the axiom-frontier
  probe, and the three companion measurements in its header: reachability of the
  headline cone, whether every module on disk is rooted at all, and whether every
  blueprint proof-level `\leanok` is honest.  The last has to be a `#print axioms` join
  rather than a reading pass, because a `\leanok` is a local mark while the defect is
  transitive — a proof written in Lean is still not proved if it routes through a `sorry`.
  The `\leanok` join is executable — `scripts/leanok-audit.sh`, one command from the
  project root, exiting non-zero if any of its three checks fails (the reconciliation
  identity on each mark position, plus a positive control proving the `private` lane
  still bites).  Run it rather than re-transcribing it: every wrong number this check has
  published came from a recipe copied out of a comment and drifting from the code that
  produced it.

  > [!WARNING]
  > **The audit's positive control has gone stale (inbox `I-0545`, 2026-07-28), so its
  > clean verdicts currently prove nothing.**  Its control
  > `av_indeterminacyLocus_eq_empty` no longer reports `sorryAx` — `ajc-albanese` proved
  > Milne 3.3 — so the check can no longer demonstrate that it still detects what it was
  > built to detect.  Re-pick a control before quoting a result.  `I-0545` also names one
  > genuine proof-level defect: `def:inst_has_pic_scheme` pins
  > `picSchemeOfHasRationalPoint`, which reports `sorryAx` at HEAD.

  Last published result, both mark positions under the same reconciliation identity:
  **proof-level, 1073 pinned declarations across 1078 marks = 930 public + 143 `private`,
  zero carrying `sorryAx`; statement-level, 1560 declarations across 1567 marks = 1372
  public + 188 `private`, of which 34 carry `sorryAx`.**  Only the proof-level zero is a
  defect count: a statement-level mark on a `sorry` carrier is legitimate, since it claims
  the signature is formalised.  Do not delete those 34.

  Before writing another mechanical audit, read this one's history — it is the sharpest
  cautionary tale in the tree, kept in inbox memory `I-0483`.  Short form: a mechanical
  audit needs an arithmetic identity it must satisfy, asserted in code
  (`public + private + unresolved == pins`), or "it printed 0 defects" means only that it
  printed; a domain bug is not fixed when one of its instances is; and "my probe cannot
  see it" is a fact about the probe.
- [`blueprint/web/index.html`](blueprint/web/index.html): generated mathematical blueprint.
- [`analogies/README.md`](analogies/README.md): index to the historical design notes.
- [`../Algebraic-Jacobian-Challenge-Rebuild/README.md`](../Algebraic-Jacobian-Challenge-Rebuild/README.md):
  the alternative Rebuild route.

## Layout

- `AlgebraicJacobian/Cohomology/`: sheaf cohomology, the finite-cover Čech
  complex, higher direct images, and flat base change.
- `AlgebraicJacobian/Picard/`: line bundles, relative Spec, the relative Picard
  functor, Grassmannians, Quot schemes, flattening stratification, and Picard
  identity components.
- `AlgebraicJacobian/Albanese/`: rigidity and extension of rational maps, plus the
  Albanese factorization.
- `AlgebraicJacobian/RiemannRoch/`: divisor and adelic Riemann–Roch infrastructure.
  `RiemannRoch/Ledger/` (51 files) is the χ-ledger ported from the sibling
  Algebraic-Jacobian-Challenge-Rebuild project, plus four AJC-native rederivations and
  the fibrewise large-twist vanishing layer.  Partly rooted (37 of 51, via
  `WeilDivisor.lean`); the remaining 14 are outside the root cone — see the rootedness
  note above and inbox issue `I-0600`.
- `blueprint/src/chapters/`: the mathematical blueprint.
- `hgraph/`: the generated statement/declaration dependency graph.
- `scripts/`: import-minimization and budget-trimming helpers (`min-imports.sh`,
  `deumbrella.sh`, `deumbrella-wave.sh`, `trim-budgets.sh`).  They drive
  `lake env lean`, never `lake build`, so they do not invalidate the build tree.
- `informal/`, `memory/`, `analogies/`: campaign plans, durable notes, and
  historical design notes.  See each directory's own index.
- [`../../references/summary.md`](../../references/summary.md): shared source
  bibliography and retrieval notes.

## Build

Lean and Mathlib are both pinned at `v4.31.0`.

```bash
lake exe cache get
lake build
```

For faithful checks, prefer the configured module target.  `lake env lean <file>`
does not apply every option from the lakefile's `[leanOptions]` — in particular
`maxSynthPendingDepth` — so a direct-file-only instance-synthesis failure can be an
option mismatch rather than a source regression.  Files that rely on that option
carry a local `set_option` so direct-file, LSP, and module checks agree.

This project is part of an Archon Horizon workspace.  Roadmap, task, inbox, and
cross-project state live at the workspace root and are reached through the
`horizon` CLI.
