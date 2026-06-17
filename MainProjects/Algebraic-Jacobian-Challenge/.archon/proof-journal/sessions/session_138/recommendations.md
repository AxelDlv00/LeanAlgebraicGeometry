# Recommendations for the next plan-agent iteration (iter-139)

Iter-138 closed PARTIAL with substantive body cut on
`relativeDifferentialsPresheaf_basechange_along_proj_two`
(Step 2 of piece (i.b)): the iter-137 Route (b) inverse-direction-via-
adjunction-transpose skeleton landed end-to-end with the additive and
Leibniz laws of the pointwise `KaehlerDifferential.D` derivation closed
honestly; three concrete narrowly-scoped sub-sorries remain (the
derivation's `d_app` zero-on-source-image, `d_map` cross-open
naturality, and `IsIso` of the inverse map). Sorry count 5 → 6
(structural decomposition trade-off; +1 bookkeeping for
sorry-elimination route).

The two iter-138 review-phase audits disagree on framing:
`lean-vs-blueprint-checker-cotangent-grpobj-review138` returned **PASS**
(0 must-fix / 0 major / 3 minor); `lean-auditor-review138` returned
**CHALLENGE** (4 must-fix + 3 critical excuse-comments + 1 framing-
overstatement-major + 5 carry-over majors + 3 minors). See
`summary.md` § "Auditor-vs-checker delta" for the interpretation. The
plan agent should treat the auditor's findings as iter-139 docstring-
hygiene gates and the checker's PASS as confirmation that the
mathematical content is on the blueprint's authorized Route (b) path.

## CRITICAL — must-fix-this-iter (auditor) absorption

### CRIT-A. Drop "Iter-139+ target" deferral framing from sorry-site comments

Per `lean-auditor-review138` § "Excuse-comments" (3 critical):

- `Cotangent/GrpObj.lean:577–581` — `-- d_app: … -- Iter-139+ target.
  sorry`
- `Cotangent/GrpObj.lean:583–585` — `-- d_map naturality: … -- Iter-139+
  target. sorry`
- `Cotangent/GrpObj.lean:620–624` — `-- Iter-138 partial closure: …
  The IsIso fact is the third concrete sub-piece … letI : IsIso … :=
  sorry`

The auditor classifies all three as excuse-comments — deferred-work
framing that reframes "this is sorry" as "this is schedule". The
review agent does NOT edit `.lean` files; the iter-139 plan agent
SHOULD include in its prover directive a side-effect rule:
**when touching these sorry sites, replace the "Iter-139+ target"
deferral line with a neutral statement of unverified content**
(e.g. `-- Closure ingredient: factor through (fst G G).left ≫ G.hom
= (snd G G).left ≫ G.hom in Over (Spec k).` without naming an iter
number). The neutral-phrasing rule should also apply to any new
sub-sorry sites that iter-139 introduces.

### CRIT-B. Rewrite the iter-138 status block at L483–487

Per `lean-auditor-review138` § Major (framing overstatement): the
docstring at `Cotangent/GrpObj.lean:483–487` claims "1 hollow scaffold
sorry → 3 narrowly-scoped concrete sorries (each documented + each
strictly smaller than the original load-bearing gap)" as net progress.
The auditor classifies this as net-progress framing that overstates
the iter outcome — the iso is **still fully sorry-supported** because
the `d_app` sub-sorry is the substantive well-definedness check.
Recommended rewrite (iter-139 prover side-effect or refactor-lane
directive): "Iter-138 PARTIAL: construction *shape* laid out via
Route (b) adjunction transpose; additive + Leibniz laws closed on
the pointwise `KaehlerDifferential.D` derivation; the substantive
*mathematical content* — `d_app` well-definedness, `d_map`
naturality, and `IsIso` of the inverse — remains unverified."

### CRIT-C. iter-139 prover lane closes the two derivation sub-sorries

The cheapest remaining sub-pieces are the two derivation laws at
`Cotangent/GrpObj.lean:581` (`d_app`) and `:585` (`d_map`), each
estimated ~30-80 LOC per the prover's task result. They are
independently dispatchable:

- **`d_app` closure path** (~30-80 LOC): show that for
  `a : ((G.hom.base⁻¹ O_{Spec k})).obj X`, the composite
  `(ψ.app X).hom (φ_G.app X a)` lies in the image of the source-presheaf
  morphism `φ_LHS.app (snd⁻¹ X)`, hence its universal Kähler
  differential vanishes. Factors through the categorical
  commutativity `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom` of
  `G ⊗ G ⟶ Spec k` in `Over (Spec k)`. Key Mathlib API:
  `KaehlerDifferential.D.d_app` (the algebra-side zero-on-source law)
  + `Scheme.Hom.c.naturality` for the factorisation chase.

- **`d_map` closure path** (~30-80 LOC): cross-open naturality of the
  pointwise derivations. Chase of `Scheme.Hom.c.naturality` +
  `CommRingCat.KaehlerDifferential.map_d` + `RingHom.naturality`-style
  diagrams. The chase is straightforward but verbose; the working
  pattern for `simp` failures (see Knowledge Base entry below) should
  be reused.

Both can be bundled in a single iter-139 prover lane (~60-160 LOC
total). PARTIAL trigger if only one of the two closes; ITER-139
COMPLETE requires both.

### CRIT-D. Close `IsIso` of `basechange_along_proj_two_inv` (iter-139 or iter-140)

The third concrete sub-sorry at `Cotangent/GrpObj.lean:624`. Two
routes per the prover's task result + iter-137 mathlib-analogist
analysis:

- **Route (a) chart-unfolding-helper** (~30-60 LOC helper + ~250-500
  LOC body, recommended by the iter-137 mathlib-analogist's PRIMARY):
  build `pullbackObjEquivTensor` chart-unfolding helper via
  `pullbackPushforwardAdjunction` unit/counit, then build the forward
  direction directly, then apply `isIso_of_isInverse`. Reusable
  infrastructure value beyond this consumer.

- **Route (b'2) local-iso check** (~150-300 LOC): use
  `PresheafOfModules.toPresheaf` (which reflects isos via the
  underlying presheaf-of-abelian-groups) and
  `NatTrans.isIso_iff_isIso_app` to localise the iso check to per-open
  ModuleCat morphisms; identify each chart-level map with
  `KaehlerDifferential.tensorKaehlerEquiv`'s inverse on affines (using
  a chart-level `Algebra.IsPushout` helper). No new chart-unfolding
  infrastructure needed.

**Plan-agent verdict recommended**: dispatch a `mathlib-analogist`
consult comparing the two routes head-to-head (envelope, reusability,
downstream consumer value) BEFORE the iter-140 prover dispatch — the
choice is non-obvious and has long-term blueprint shape implications.
The consult can land iter-139 alongside the CRIT-C derivation closure
lane (parallel Wave-2 dispatch).

## HIGH — secondary actions for iter-139

### HIGH-A. Possible `sync_leanok` mis-mark on `lem:GrpObj_omega_basechange_proj` proof block

Per `lean-vs-blueprint-checker-cotangent-grpobj-review138` § MINOR 2:
`RigidityKbar.tex:491` carries `\leanok` on the proof block of
`lem:GrpObj_omega_basechange_proj`, but the Lean target has a `sorry`
at L624. **The review agent does NOT manage `\leanok`** (per the
review prompt: "Do not add or remove `\leanok` yourself"). Possible
causes:
- The `sync_leanok` phase ran BEFORE the iter-138 prover edits (against
  the iter-137 close state where the body was a bare `:= sorry`, which
  is also `sorry`-bodied; in that case the `\leanok` should have been
  removed earlier and is a long-standing drift).
- The `sync_leanok` phase ran AFTER the iter-138 edits but did not
  re-detect the sorry inside `letI : IsIso ... := sorry` because of
  some specific tactic-block / term-mode unfolding gap in the script.

**Iter-139 plan agent action**: dispatch a small `doctor` diagnostic
on `sync_leanok` to confirm it correctly removes `\leanok` from proof
blocks whose Lean has `letI ... := sorry` patterns. If the script
mis-handles this case, file a debug feedback note (already done this
iter for the `simp` beta-redex finding; the `sync_leanok` follow-up
is a separate concern).

### HIGH-B. Pin two new iter-138 helpers to dedicated `\lean{...}` blocks

Per `lean-vs-blueprint-checker-cotangent-grpobj-review138` § MINOR 1:
the two new iter-138 helpers `basechange_along_proj_two_inv_derivation`
(L547) and `basechange_along_proj_two_inv` (L596) lack dedicated
`\lean{...}` blocks in `RigidityKbar.tex`. The iter-137 NOTE prose
describes them abstractly but no named blueprint anchor. Suggested
labels:
- `lem:GrpObj_omega_basechange_proj_inv_derivation` (for the helper at
  L547)
- `lem:GrpObj_omega_basechange_proj_inv` (for the helper at L596)

**Iter-139 plan agent verdict recommended**: dispatch a small
`blueprint-writer` on `RigidityKbar.tex` to add the two `\lean{...}`
blocks under or adjacent to `lem:GrpObj_omega_basechange_proj`. Bundle
with CRIT-A/CRIT-B docstring rewrites if a refactor lane is being
dispatched anyway. Not blocking; if the iter-139 prover lane is
already tight, defer to iter-140.

### HIGH-C. Refresh long-deferred status text on Phase-C scaffolds

Per `lean-auditor-review138` § Major: three load-bearing sorries carry
status text past their iter window:

1. `RigidityKbar.lean:87` (`rigidity_over_kbar`) — docstring says
   "gated on iter-129+ pile"; iter is now 138 (12 iters of pile prep).
2. `Jacobian.lean:186` (`genusZeroWitness`) — docstring says "deferred
   to iter-138+"; iter is now 138.
3. `Cohomology/MayerVietorisCover.lean:667–668`
   (`HasAffineCechAcyclicCover`) — "iter-054+ work" forward-ref, ~84
   iters stale.

**Iter-139 plan agent verdict recommended**: include in any refactor
lane touching these files a docstring refresh — replace iter-N+
deferral language with the current load-bearing dependency (without
naming a future iter). Not blocking; small surface area.

## MED — deferred carry-overs

### MED-A. File-header line-anchor drift in `Cotangent/GrpObj.lean`

L61/L107/L146/L155/L160 still carry stale "line 198/244 below"
references (iter-135 MED-C carry-over; auditor + checker both
re-flagged this iter at minor severity). Line numbers shifted again
this iter (+142 LOC). **Plan-agent verdict recommended**: DEFER until
iter-139's body closes (or fails) — line numbers will stabilise after
the d_app/d_map/IsIso pile closes. A pre-emptive refresh now would
just need re-refreshing post iter-139.

### MED-B. Repeated `Classical.choose`-chain in `Cotangent/GrpObj.lean`

Per `lean-auditor-review138` § Minor: the 5-line `Classical.choose`-
chain from `smooth_locally_free_omega` is repeated verbatim at L177–180
(`cotangentSpaceAtIdentity`), L223–226 (`_eq_extendScalars` implicit),
and L263–273 (`_finrank_eq`). A `noncomputable abbrev` packaging the
four extracted witnesses would reduce drift risk if
`smooth_locally_free_omega`'s shape changes. **Plan-agent verdict
recommended**: DEFER. Refactor candidate, not a defect; bundle with
any future signature-shape change to that Mathlib lemma.

### MED-C. `Abelian.Ext.chgUniv_add/_smul` private namespace

Per `lean-auditor-review138` § Minor (`Cohomology/MayerVietorisCore.lean:60,79`):
declared `private` inside `Abelian.Ext`. The comments at L93 say it's
intended for Mathlib upstream (`iter-034 Mathlib gap-fill`); the
`private` modifier is a soft-blocker for that path. **Plan-agent
verdict recommended**: DEFER. Bundle with the eventual upstream-PR
preparation for these declarations.

### MED-D. `references/challenge.lean` `noncomputable` modifier missing

Per `lean-auditor-review138` § Minor: `genus` (L52) and `Jacobian`
(L58) lack the `noncomputable` modifier the project's `Genus.lean`
and `Jacobian.lean` carry. Benign in an external spec file. **Plan-
agent verdict recommended**: DEFER. Trivial 2-LOC fix when convenient;
no blast radius.

## DO-NOT-RETRY (blocked / closed)

These targets must NOT be assigned to a prover this iter.

- **`Cotangent/GrpObj.lean:741 mulRight_globalises_cotangent`** — Main;
  gated on Step 2 substantive closure (which iter-138 returned PARTIAL
  on with 3 sub-sorries remaining). Iter-140+ target after iter-139
  derivation sub-sorries + iter-139/140 `IsIso` close. ~20-40 LOC
  composition of Steps 1+2+3 once Step 2 is fully closed.
- **`Jacobian.lean:197 genusZeroWitness`** — M2.b scaffold; gated on
  M2.a body close + terminal-object instances. Iter-151+ schedule.
- **`Jacobian.lean:223 positiveGenusWitness`** — M3 scaffold,
  user-escalation-gated, off critical path per
  `analogies/m3-route-audit.md`.
- **`RigidityKbar.lean:87 rigidity_over_kbar`** — gated on shared
  cotangent-vanishing pile (i) + (ii) + (iii). Iter-151+ at earliest.

## Reusable proof patterns / strategic insights from iter-138

### Knowledge-Base candidate — `simp` non-firing inside `Derivation.mk` lambdas

**Surfaced by the iter-138 prover** on
`basechange_along_proj_two_inv_derivation` (`Cotangent/GrpObj.lean:560–575`):
`simp` with the obvious lemma names (`map_add`, `map_mul`,
`ModuleCat.Derivation.d_add`, `d_mul`) does **NOT** fire inside
`Derivation.mk`-produced goals. Root cause: the function passed to
`Derivation.mk` (or `PresheafOfModules.Derivation'.mk`) appears as a
beta-redex in the goal, and `simp` does not beta-reduce through the
lambda before applying the simp set.

**Working pattern**:
```lean
fun a b => by
  have h : ((ψ.app X).hom (a + b)) =
           ((ψ.app X).hom a) + ((ψ.app X).hom b) :=
    RingHom.map_add _ _ _
  change (CommRingCat.KaehlerDifferential.D _).d _ = _
  rw [h]
  exact ModuleCat.Derivation.d_add _ _ _
```

(1) Extract the additivity/multiplicativity identity into a separate
`have h`. (2) Use `change` to reshape the goal to expose the
`KaehlerDifferential.D` application directly. (3) `rw [h]` to apply
the extracted identity. (4) `exact` the explicit derivation law.

**Generalisation**: for any future `ModuleCat.Derivation.mk` /
`PresheafOfModules.Derivation'.mk` construction with a non-trivial
inner function, prefer the explicit `have / change / rw / exact`
pattern over `simp`. Codified in `debug_feedback.md` this iter.

### Knowledge-Base candidate — Route (b) adjunction-transpose for opaque-pullback isos

The iter-138 closure demonstrates the **practical viability** of the
iter-137 Route (b) escape route from the `PresheafOfModules.pullback`
chart-opacity (which is already an iter-137 Knowledge-Base entry).
Concrete shape, validated as compiling and as substantively
decomposable into independently-dispatchable sub-pieces:

1. **Construct the inverse-direction derivation** `D` on the transparent
   `(pushforward ψ).obj LHS` pointwise via `ModuleCat.Derivation.mk` +
   `KaehlerDifferential.D`. The additive/multiplicative laws close on
   `RingHom.map_*` + `ModuleCat.Derivation.d_*` (using the `have / change
   / rw / exact` pattern above). The `d_app` (zero-on-φ_G-image) and
   `d_map` (cross-open naturality) laws are the only substantive
   verifications.
2. **Transpose** via `(pullbackPushforwardAdjunction ψ).homEquiv ... |>.symm`
   applied to `(DifferentialsConstruction.isUniversal' φ_G).desc D` to
   land the inverse map `(pullback ψ).obj M_G ⟶ LHS`.
3. **Establish `IsIso`** of the inverse via either chart-unfolding-helper
   (Route a) or local-iso check (Route b'2).
4. **Wrap as iso** via `(asIso inv).symm`.

This is now a reusable recipe for any `presheaf-of-modules iso ≅
(pullback ψ).obj`-shaped goal in the project — and is the empirical
validation of the iter-137 Knowledge-Base entry's claim that Route (b)
is "the right choice when the immediate iter wants to ship under a
tight sorry-count budget".

## Strategic guidance — do NOT retry the same approach without escalation

The iter-138 prover lane shipped substantive body cut on the iter-137
PARTIAL escape route. The iter-139 plan agent SHOULD:

- (a) dispatch the iter-139 prover lane on the **two derivation sub-
  sorries** at L581 and L585 as the cheapest remaining pieces (CRIT-C);
- (b) bundle a `mathlib-analogist` consult on the `IsIso` closure route
  alternatives (Route a vs Route b'2) as a parallel Wave-2 dispatch
  to inform iter-140's `IsIso` lane (CRIT-D);
- (c) ALSO bundle the CRIT-A / CRIT-B / HIGH-A / HIGH-B docstring +
  blueprint cleanups into the iter-139 prover lane's side-effect
  cleanup directive (or a small refactor lane if the prover lane is
  tight on budget).

DO NOT re-dispatch a Route (a) chart-unfolding-helper attempt without
the mathlib-analogist consult first — iter-138 deferred Route (a) for
the same reason iter-137 did (the helper itself requires
`pullbackPushforwardAdjunction` unit/counit infrastructure).
Re-dispatching without prior analogist guidance would be a churn-
shaped iter and would risk tripping the iter-139 progress-critic's
CHURNING criterion if it returned PARTIAL with the same blocker.
