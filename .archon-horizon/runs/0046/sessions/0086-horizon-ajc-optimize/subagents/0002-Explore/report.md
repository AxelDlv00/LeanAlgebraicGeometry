## 1. `analogies/README.md` — exact current content (22 lines, 1086 B, mtime 2026-07-25 23:00)

```markdown
# Historical Design Notes

This directory preserves exploratory comparisons, API surveys, and route
decisions from earlier formalization campaigns. It is supporting history, not
the current project plan or mathematical blueprint. Some notes refer to old
iteration numbers, declarations, or file layouts and should be checked against
the current tree before reuse.

For current state, use:

- `horizon roadmap list --focus AJC.jacobian` for the proof and maintenance plan;
- `horizon inbox list --project Algebraic-Jacobian-Challenge` for open issues and
  durable failure memory;
- `horizon graph -p Algebraic-Jacobian-Challenge frontier` for declaration-level
  dependencies and the formalization frontier.

The filenames are searchable by topic: `cech` and `fbc` cover cohomology and
flat base change; `pic`, `quot`, and `tensor` cover Picard representability; and
`rigidity`, `cotangent`, and `differential` cover the Picard identity component.
New status reports and dead ends belong in the roadmap, inbox, or graph comments
rather than as additional iteration-numbered files here.
```

Structure: H1 + 1 disclaimer para + a 3-bullet "use horizon instead" list + 1 topic-keyword para. No per-file index, no keep/retire distinction, and the last topic sentence is **factually wrong now**: `rigidity`/`cotangent`/`differential` notes cover the *deleted* genus-0 lane, not the Picard identity component.

## 2. `analogies/` inventory (124 files, 1.84 MB)

Two mtime cohorts only. **107 files are stamped `2026-06-17 16:54`** (bulk git-import stamp — not creation time; real recency is the `## Iteration` number). **16 files carry true later mtimes (06-24 → 07-01) and are exactly iterations 304–329.** README is 07-25.

| iter | file | bytes | date |
|---|---|---|---|
| — | README.md | 1086 | 2026-07-25 |
| — | cech-koszul-precedent.md | 20325 | 06-17 |
| — | ts-monoidalloc214.md | 7105 | 06-17 |
| 106 | finite-product-localisation-and-cech-r-linearity.md | 18625 | 06-17 |
| 108 | c1-route.md | 13556 | 06-17 |
| 110 | serre-duality.md † | 16512 | 06-17 |
| 114 | affine-basis-sheaf-bridge.md † | 13324 | 06-17 |
| 120 | cotangent-presheaf-design.md † | 16648 | 06-17 |
| 121 | relative-differentials-presheaf-bridge.md † | 25710 | 06-17 |
| 123 | m3-route-audit.md | 23899 | 06-17 |
| 124 | rigidity-refactor.md † | 12249 | 06-17 |
| 126 | cotangent-vanishing-pile.md † | 21635 | 06-17 |
| 127 | cotangent-vanishing-pile-over-k.md † | 20010 | 06-17 |
| 129 | lieAlgebra-rank-bridge.md † | 16389 | 06-17 |
| 131 | cotangent-body-shape.md † | 20764 | 06-17 |
| 133 | mulright-globalises-cotangent.md † | 16001 | 06-17 |
| 135 | phi-compatibility-morphisms.md † | 9452 | 06-17 |
| 137 | kaehler-tensorequiv-presheafpullback.md † | 16383 | 06-17 |
| 138 | differential-containConstants-alignment.md † | 25211 | 06-17 |
| 138 | p1-hedge-genus-zero-witness.md † | 13250 | 06-17 |
| 139 | isiso-basechange-along-proj-two-inv.md † | 14783 | 06-17 |
| 140 | direct-chart-algebra-rigidity-ib-ic.md † | 24083 | 06-17 |
| 141 | d-app-d-map-recipe-shape.md † | 16381 | 06-17 |
| 141 | scheme-frobenius-piece-iii-scoping.md † | 27869 | 06-17 |
| 144 | chart-algebra-vs-bundled-iter144.md † | 29976 | 06-17 |
| 145 | m3-route-a-refresh-iter145.md | 21575 | 06-17 |
| 148 | step-e-iter148.md † | 11971 | 06-17 |
| 150 | h1cotangent-vanishing-iter150.md † | 18905 | 06-17 |
| 154 | ftthree-kernel-iter154.md † | 13534 | 06-17 |
| 155 | df-zero-production-iter155.md † | 11776 | 06-17 |
| 159 | rigidity-affineconst.md † | 6977 | 06-17 |
| 159 | rigidity-hfib.md † | 6149 | 06-17 |
| 163 | route-support.md † | 8162 | 06-17 |
| 164 | thm32-extend.md † | 11348 | 06-17 |
| 165 | gm-scaling-p1.md † | 17875 | 06-17 |
| 167 | gm-grpobj-and-friends.md † | 25591 | 06-17 |
| 168 | gmscaling-deep.md † | 33854 | 06-17 |
| 168 | rrbridge-survey.md † | 14414 | 06-17 |
| 170 | tensoraway-instance.md † | 9969 | 06-17 |
| 173 | chart-bridge.md † | 14297 | 06-17 |
| 174 | chart-bridge-shared-helper.md † | 22093 | 06-17 |
| 174 | qcohalgebra-structure.md | 14039 | 06-17 |
| 175 | chart-bridge-structural-pivot.md | 18663 | 06-17 |
| 175 | dvr-rationalmap-order.md | 10585 | 06-17 |
| 178 | gmscaling-cover-bridge.md † | 17239 | 06-17 |
| 178 | relative-spec-encoding.md | 18089 | 06-17 |
| 179 | gm-grpobj-representable.md † | 13668 | 06-17 |
| 180 | pullbackspeciso-bypass.md † | 19326 | 06-17 |
| 181 | ratcurveiso-pin2.md † | 8322 | 06-17 |
| 181 | ratcurveiso-pin3.md † | 10441 | 06-17 |
| 182 | intersection-ring-cross01.md † | 24699 | 06-17 |
| 182 | isregularlocalring-isdomain.md | 10089 | 06-17 |
| 182 | ocofp-sheaf-internalhom.md † | 14716 | 06-17 |
| 182 | quotscheme-pullback-affine-section.md | 14086 | 06-17 |
| 182 | stacks-00tt-coheight.md | 19420 | 06-17 |
| 184 | gmscaling-projection-idiom.md † | 20948 | 06-17 |
| 185 | ocofp-carrierset-submodule-api.md † | 22090 | 06-17 |
| 187 | quotscheme-isbasechange-tilde.md | 15010 | 06-17 |
| 189 | lane-b-substrate.md † | 23187 | 06-17 |
| 189 | lane-e-projappiso.md † | 7761 | 06-17 |
| 189 | lane-f-isbasechange.md | 13622 | 06-17 |
| 191 | lane-a3i-isconnected-prod.md | 14628 | 06-17 |
| 191 | lane-f-restrictscalars-smul.md | 13354 | 06-17 |
| 195 | carrier-soundness-design.md | 15511 | 06-17 |
| 195 | lane-a3i-stacks-04kv.md | 15603 | 06-17 |
| 195 | lane-e-proj-appiso-pivot.md † | 22061 | 06-17 |
| 197 | pic0-ker-deg-pivot.md | 15079 | 06-17 |
| 199 | coe-stacks02jk.md | 11766 | 06-17 |
| 200 | coe-stacks00oe.md | 16678 | 06-17 |
| 200 | wd-stacks02iz.md | 13762 | 06-17 |
| 206 | ts-design206.md | 8116 | 06-17 |
| 207 | mate207.md | 7944 | 06-17 |
| 208 | tsroute208.md | 9705 | 06-17 |
| 210 | ts-assoc-gate210.md | 8558 | 06-17 |
| 213 | ts-monoidal213.md | 11940 | 06-17 |
| 215 | ts-d2-feasibility-215.md | 10802 | 06-17 |
| 216 | ts-picard-direct-216.md | 8845 | 06-17 |
| 217 | ts217.md † | 7441 | 06-17 |
| 219 | ts219dual.md | 7677 | 06-17 |
| 224 | ts224dual.md | 9568 | 06-17 |
| 226 | ts226descent.md | 10222 | 06-17 |
| 229 | ts229slice.md | 9193 | 06-17 |
| 231 | ts231ih.md | 7365 | 06-17 |
| 233 | monoidal-transport.md | 8996 | 06-17 |
| 235 | fbc-dict.md | 11311 | 06-17 |
| 240 | fbc-qc.md | 7022 | 06-17 |
| 240 | pullback-monoidal.md | 8200 | 06-17 |
| 241 | pbu-canon.md | 9802 | 06-17 |
| 242 | pullback-tensor.md | 10445 | 06-17 |
| 244 | presheaf-pullback-strong.md | 8587 | 06-17 |
| 245 | invertible-loctriv-bridge.md | 10239 | 06-17 |
| 245 | rpf-pullback-bridge-granularity.md | 10152 | 06-17 |
| 247 | eta247.md | 6340 | 06-17 |
| 250 | eps250.md | 10011 | 06-17 |
| 251 | d3-251.md | 12199 | 06-17 |
| 252 | dual252.md | 8608 | 06-17 |
| 252 | engine252.md | 9341 | 06-17 |
| 252 | whisker252.md | 10280 | 06-17 |
| 254 | tscmp254.md | 10792 | 06-17 |
| 255 | mapin255.md | 6558 | 06-17 |
| 257 | dualstep4-257.md | 9851 | 06-17 |
| 258 | d3sq2b258.md | 9736 | 06-17 |
| 258 | overeq258.md | 9807 | 06-17 |
| 260 | pushforwardcomp-lax-mu260.md | 7531 | 06-17 |
| 262 | ma-legb262.md | 6952 | 06-17 |
| 263 | ma-ihom263.md | 6348 | 06-17 |
| 264 | ma-d3264.md | 9613 | 06-17 |
| 271 | d3-mate271.md | 11358 | 06-17 |
| 304 | 02kh-leaves-304.md | 10371 | 06-24 |
| 305 | fbc-locality-305.md | 11601 | 06-25 |
| 306 | coherence-pred-306.md | 7532 | 06-25 |
| 306 | d3-mate-306.md | 10557 | 06-25 |
| 309 | d3-mate-recast-309.md | 8685 | 06-25 |
| 309 | dualcoerce309.md | 4875 | 06-25 |
| 310 | pullback-spelling-310.md | 7970 | 06-25 |
| 313 | dualcoerce313.md | 7321 | 06-29 |
| 317 | fbc-pushpull-tilde-317.md | 8574 | 06-29 |
| 322 | ptc-cmpleg-slide-322.md | 11828 | 06-30 |
| 325 | ptc-carrier-reconcile-325.md | 7741 | 06-30 |
| 326 | openimm-beckchevalley-326.md | 11480 | 06-30 |
| 326 | ptc326.md | 10157 | 06-30 |
| 327 | fbc327.md | 7757 | 06-30 |
| 328 | keystone328.md | 7367 | 06-30 |
| 329 | fbc329.md | 8866 | 07-01 |

† = the note names a module deleted in the 2026-06-23 genus-split removal (`Cotangent/`, `Genus0BaseObjects/`, `Differentials.lean`, `Rigidity.lean`, `RigidityKbar`, `AbelianVarietyRigidity`, `RRFormula`, `H1Vanishing`, `OCofP`, `RationalCurveIso`). **47 of 123 notes carry this flag.**

## 3. Per-file verdicts

### analogies/ — 15 sampled (spanning iter 110→329, 4.8 KB→33.8 KB)

```
gmscaling-deep.md (33854, largest)      | RETIRE | transcription recipe for gmScalingP1 in Genus0BaseObjects.lean — 0 grep hits, module deleted 06-23
chart-algebra-vs-bundled-iter144.md     | RETIRE | iteration re-evaluation gate over Cotangent/GrpObj.lean decls (mulRight_globalises_cotangent, basechange_along_proj_two_inv_*) — all 0 hits; cites deleted STRATEGY.md
serre-duality.md                        | RETIRE | targets serre_duality_genus in deleted Differentials.lean; its "Mathlib has no Serre duality" finding is restated and superseded by informal/pic-representability-campaign.md's duality-free P5 pin
eta247.md                               | RETIRE | pure PROCEED clearance ("every lemma the prover named exists"); no divergence, no wall — the plan was executed
keystone328.md                          | RETIRE | plan executed: isIso_iff_isIso_restrict now lives at Cohomology/ModulesCoverConservativity.lean:37; its dead-end clause duplicates 02kh-leaves-304
02kh-leaves-304.md (4.8K-33K mid)       | KEEP   | records the still-binding wall "no stalk functor for (pre)sheaves of modules; pullback is an opaque leftAdjoint with no pointwise data" + the cosimplicial-natural-iso granularity rule for CechHigherDirectImageUnconditional (33 sorries)
fbc329.md (newest, iter 329)            | KEEP   | soundness finding that openImmersion_beckChevalley's arbitrary-F signature is FALSE + minimal hypothesis set + brick route; decl still sorried at :914; explicitly retires fbc327
coherence-pred-306.md                   | KEEP   | ALIGN verdict binding genericFlatness + 6 siblings to Mathlib's SheafOfModules.IsFinitePresentation instead of a bespoke IsCoherent; FlatteningStratification.lean still open
ptc326.md                               | KEEP   | discr-tree analysis of why no global Sheaf.val-keyed MonoidalCategoryStruct may be added and why the letI inferInstanceAs bridge must stay — a standing constraint on TensorObjSubstrate/PullbackTensorComp
pullback-spelling-310.md                | KEEP   | corrects a false premise (Scheme.Modules.pullback IS Mathlib, not a parallel API), fixes the canonical spelling direction, names backward.isDefEq.respectTransparency false
d3-mate-recast-309.md                   | KEEP   | recorded dead end (homEquiv telescope) + the conjugateEquiv_comp reframing that unblocks the D3′ cocycle; would be re-attempted otherwise
dualcoerce309.md (4875, smallest)       | KEEP   | ConcreteCategory.hom vs ModuleCat.Hom.hom reducible-defeq gap and the erw bridge; εInv_apply still live in DualInverse.lean; a recurring project-wide friction
carrier-soundness-design.md             | KEEP   | design decision that `def Carrier := sorry` is unsound and must become existence-typeclass + Classical.choose; FGAPicRepresentability/QuotScheme/IdentityComponent still carry exactly those carrier sorries
ts-design206.md                         | KEEP   | route comparison abandoning the all-modules MonoidalClosed (PresheafOfModules) build for the flat/line-bundle subcategory — the reason Vestigial.lean exists
m3-route-audit.md                       | KEEP   | the Route-A(FGA/Picard)-vs-Route-B(symmetric-power) decision that produced the entire current Picard/ tree, plus the Mathlib-absence inventory still framing every cone
```

### informal/ — all 12

```
pic-representability-campaign.md (72K)  | KEEP   | the live plan of record for instHasPicScheme (D3 Milne–Kollár, judged winner, milestone DAG) — largest open cone
milne-lemma-3.3.md                      | KEEP   | verbatim Milne source + 4-substep Lean decomposition for the single sorry gating the whole Albanese chain; Milne33Substeps.lean/CodimOneExtension.lean live
higherDirectImage.md                    | KEEP   | records the foundational EnoughInjectives/IsGrothendieckAbelian (SheafOfModules R) Mathlib gap and the [HasInjectiveResolutions]-as-hypothesis API decision still in force
affineBaseChange_pushforward_iso.md     | KEEP   | enumerates the exact missing affine dictionary for the FBC frontier; decl still sorried in FlatBaseChange.lean
isLocallyInjective_whiskerLeft_of_W.md  | KEEP   | complete route-(d) proof (W = stalkwise iso) + why the flat route is false for invertibles over non-affine opens
chartOverIso.md                         | KEEP   | type analysis of restrict-vs-over; still the sorry in Picard/LineBundleCoherence.lean
dual_restrict_iso.md                    | KEEP   | Steps 1–4 verified-typechecking decomposition + exact residual; decl live in SheafOverEquivalence/PresheafDualPullback
KaehlerDifferential_mem_range_...md     | KEEP   | proves a stated lemma FALSE with two counterexamples (standard-smooth ≠ geometrically connected) — a dead end that would be re-attempted, even though its host ChartAlgebra.lean is gone
tensorObj_restrict_iso.md               | RETIRE | iter-208 "state in the file / compiles GREEN" snapshot with stale line numbers; its 3-step reduction is restated verbatim in dual_restrict_iso.md
exists_tensorObj_inverse.md             | RETIRE | iter-218 blocker report (opens with an informal-agent HTTP-401 incident); the dual/internal-hom route it recommends has since been built (DualInverse/, PresheafInternalHom, Vestigial)
projectiveLineBar_geomIrred.md          | RETIRE | targets Genus0BaseObjects/BareScheme.lean; `ProjectiveLineBar` = 0 grep hits, deleted genus-0 lane
projectiveLineBar_smoothOfRelDim.md     | RETIRE | same deleted lane
```

### memory/ — all 6

```
genus-split-removed-uniform-pic0.md     | KEEP   | the single most load-bearing record: what was deleted 06-23 and why; explains the 47 dead analogies and pins the WeilDivisor.lean carve boundary (T13/I-0106)
dualinverse-naturality-wall.md          | KEEP   | architectural wall (restrictScalarsLaxε absent from Mathlib) + the hom_ext per-component bypass; DualInverse.lean still open
cech-leaf2-reduced-to-flatbasechange.md | KEEP   | records that Čech leaf-2 is downstream of the FlatBaseChange frontier (still true — cechComplex_baseChange_iso still sorried) + the reusable `.X i` defeq/erw trick
MEMORY.md                               | KEEP   | the index itself; needs its d3-split-landed and ts225 bullets dropped
d3-split-landed.md                      | RETIRE | refactor progress log (file split, line numbers, "8627 jobs"); line numbers already stale
ts225-blueprint-audit.md                | RETIRE | iter-225 audit whose two action items are executed (dual infra built; extend_to_av is the live pin, rationalMap_to_av_extends has 0 hits)
```

## 4. Retire-able fraction and the identifying pattern

**Estimate: ~60% of `analogies/` is retire-able (~74 of 123), leaving ~49 keeps.** In my sample the ratio was 5/15 retire, but the sample deliberately over-weighted the recent 304–329 cohort (which is almost all keep) and the large topical surveys; the bulk mid-range is worse.

Three cheap, mechanical discriminators, in decreasing strength:

**(A) Deleted-lane grep — 47 files, near-certain RETIRE (38% of the directory on its own).**
```
grep -lE "Cotangent/|Genus0BaseObjects|Differentials\.lean|/Rigidity\.lean|RigidityKbar|AbelianVarietyRigidity|RRFormula|H1Vanishing|OCofP|RationalCurveIso" *.md
```
These target the genus-0 / Cotangent / ℙ¹ lane deleted on 2026-06-23 (see `memory/genus-split-removed-uniform-pic0.md`). Slug families: `cotangent-*`, `gm-*`/`gmscaling-*`, `chart-*`, `rigidity-*`, `ratcurveiso-*`, `ocofp-*`, `lane-b`/`lane-e`, `differential*`, `kaehler*`, `d-app-*`, `ftthree-*`, `df-zero-*`, `step-e-*`, `h1cotangent-*`, `p1-hedge-*`, `intersection-ring-*`, `lieAlgebra-*`, `thm32-extend`, `rrbridge-survey`, `route-support`, `scheme-frobenius-*`, `pullbackspeciso-*`, `tensoraway-*`, `phi-compatibility-*`, `affine-basis-sheaf-bridge`, `relative-differentials-*`, `serre-duality`, `ts217`. Verify each with one grep of its named decl against `AlgebraicJacobian/**.lean` — all such greps I ran returned zero.

**(B) `## Iteration` band + mtime cohort.** mtime is *not* creation time; the discriminator is the `## Iteration` header (usually mirrored as a filename suffix).
- **iter ≥ 304** (the 16 files with real mtimes 06-24 → 07-01): current lane, default **KEEP**. Sole exception: `fbc327.md`, which `fbc329.md` explicitly says "should be retired in favour of this".
- **iter 110–200**: dominated by (A). The survivors worth keeping are the non-† route/survey notes: `c1-route`, `m3-route-audit`, `m3-route-a-refresh-iter145`, `carrier-soundness-design`, `qcohalgebra-structure`, `relative-spec-encoding`, `chart-bridge-structural-pivot`, `dvr-rationalmap-order`, `pic0-ker-deg-pivot`, `quotscheme-*`, `lane-a3i-*`, `lane-f-*`, `isregularlocalring-isdomain`, `stacks-00tt-coheight`, `coe-stacks*`, `wd-stacks02iz`, `cech-koszul-precedent`, `finite-product-localisation-*` — these feed live `Picard/`, `Albanese/`, `RiemannRoch/` files.
- **iter 206–271** (~40 short-slug files: `ts*`, `ma-*`, `d3-*`, `dual*`, `eps250`, `eta247`, `engine252`, `whisker252`, `mapin255`, `overeq258`, `tscmp254`, `mate207`, `tsroute208`, `pbu-canon`, `pullback-*`, `fbc-dict`, `fbc-qc`, `monoidal-transport`, `presheaf-pullback-strong`, `invertible-loctriv-bridge`, `rpf-*`, `pushforwardcomp-lax-mu260`): the TensorObjSubstrate build lane, mostly landed and re-litigated by the 304–329 cohort. Expect **~half retire**. This is where the residual judgment cost sits.

**(C) Verdict-token filter (secondary, use with (B) on the 206–271 band).** 27 notes contain only `PROCEED` verdicts with no `ALIGN_WITH_MATHLIB` / `DIVERGE_INTENTIONALLY` / `NEEDS_MATHLIB_GAP_FILL` anywhere — i.e. "the plan is fine, go" clearances whose plan has since executed (`eta247` is the archetype). RETIRE those *unless* they also contain a `## Failed approaches` / "wall" / "dead end" section (that exception rescues `d3-mate-recast-309`, `lane-e-proj-appiso-pivot`, `chart-bridge-structural-pivot`, `openimm-beckchevalley-326`).

Naming/date summary for the README rewrite: **`<slug><iterN>.md` where N ≤ ~200 and the slug is in the cotangent/gm/chart/rigidity/ratcurveiso/ocofp family ⇒ retire; N ≥ 304 (equivalently, mtime ≠ `2026-06-17 16:54`) ⇒ keep; 206 ≤ N ≤ 271 ⇒ keep only if the note records a wall, a re-signature, or an intentional divergence.**
