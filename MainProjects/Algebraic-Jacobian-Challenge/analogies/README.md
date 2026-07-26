# Historical Design Notes

123 notes (1.8 MB) from earlier formalization campaigns: route comparisons, API
surveys, recorded dead ends, and iteration journals.  This is supporting history,
**not** the current plan and not the blueprint.  Nothing here is authoritative
about the present tree.

For current state use `horizon roadmap list --focus AJC.jacobian` (plan),
`horizon inbox list --project Algebraic-Jacobian-Challenge` (open issues and
durable failure memory), and `horizon graph -p Algebraic-Jacobian-Challenge
frontier` (declaration-level frontier).

## How to date a note

File mtimes are misleading: 107 of the 123 notes carry the same `2026-06-17
16:54` bulk git-import stamp, which is not when they were written.  The real
marker is the `## Iteration` header inside each note (usually mirrored in the
filename suffix).

## Classification

**Superseded — the deleted genus-0 / cotangent lane (47 notes, 872 KB, ~47% of
the directory).**  On 2026-06-23 the genus-split lane was removed in favour of a
uniform-genus `Pic⁰` (see `../memory/genus-split-removed-uniform-pic0.md`).  These
notes are written against modules that no longer exist anywhere in the tree —
`Cotangent/`, `Genus0BaseObjects/`, `Differentials.lean`, `Rigidity.lean`,
`RigidityKbar`, `AbelianVarietyRigidity`, `RRFormula`, `H1Vanishing`, `OCofP`,
`RationalCurveIso` (each verified: zero path hits under `AlgebraicJacobian/`).
They are retained only as a record of why that route was abandoned.  Identify them
with:

```bash
grep -lE "Cotangent/|Genus0BaseObjects|Differentials\.lean|/Rigidity\.lean|RigidityKbar|AbelianVarietyRigidity|RRFormula|H1Vanishing|OCofP|RationalCurveIso" *.md
```

Slug families in this class: `cotangent-*`, `gm-*` / `gmscaling-*`, `chart-*`,
`rigidity-*`, `ratcurveiso-*`, `ocofp-*`, `lane-b`/`lane-e`, `differential*`,
`kaehler*`, `serre-duality`, `thm32-extend`, `rrbridge-survey`, `route-support`.

**Current — iterations ≥ 304 (16 notes).**  The only cohort with genuine mtimes
(2026-06-24 → 07-01), and the only one written against the live tree.  Treat as
live unless a later note retires it (`fbc329.md` explicitly retires `fbc327.md`):
`02kh-leaves-304`, `fbc-locality-305`, `coherence-pred-306`, `d3-mate-306`,
`d3-mate-recast-309`, `dualcoerce309`, `pullback-spelling-310`, `dualcoerce313`,
`fbc-pushpull-tilde-317`, `ptc-cmpleg-slide-322`, `ptc-carrier-reconcile-325`,
`openimm-beckchevalley-326`, `ptc326`, `fbc327`, `keystone328`, `fbc329`.

**Mixed — iterations 206–271 (~40 notes).**  The `TensorObjSubstrate` build lane
(`ts*`, `ma-*`, `d3-*`, `dual*`, `eps250`, `eta247`, `engine252`, `whisker252`,
`mapin255`, `overeq258`, `tscmp254`, `mate207`, `tsroute208`, `pbu-canon`,
`pullback-*`, `fbc-dict`, `fbc-qc`, `monoidal-transport`,
`presheaf-pullback-strong`, `invertible-loctriv-bridge`, `rpf-*`,
`pushforwardcomp-lax-mu260`).  Mostly landed and re-litigated by the ≥ 304 cohort,
but **not individually adjudicated**.  Keep a note here only if it records a wall,
a re-signature, or an intentional divergence; a note whose only verdict is
`PROCEED` is a clearance whose plan has since executed.

**Keep — route decisions and topical surveys (iterations 106–200, non-superseded).**
These still frame live cones: `m3-route-audit` and `m3-route-a-refresh-iter145`
(the Route-A/Route-B decision that produced the entire `Picard/` tree),
`carrier-soundness-design` (why `def Carrier := sorry` is unsound), `c1-route`,
`qcohalgebra-structure`, `relative-spec-encoding`, `chart-bridge-structural-pivot`,
`dvr-rationalmap-order`, `pic0-ker-deg-pivot`, `quotscheme-*`, `lane-a3i-*`,
`lane-f-*`, `isregularlocalring-isdomain`, `stacks-00tt-coheight`, `coe-stacks*`,
`wd-stacks02iz`, `cech-koszul-precedent`, `finite-product-localisation-*`.

## Convention

New status reports and dead ends belong in the roadmap, the inbox, or graph
comments — not as additional iteration-numbered files here.
