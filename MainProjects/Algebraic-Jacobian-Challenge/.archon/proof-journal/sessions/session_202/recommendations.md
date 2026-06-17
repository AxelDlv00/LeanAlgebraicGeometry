# Recommendations for iter-203 plan agent

## Headline

**Lane AB is DONE.** `RingTheory.auslander_buchsbaum_formula` (and `_succ_pd`)
are fully axiom-clean — the 16+-iter gap is closed. Do NOT re-assign any AB
prover lane for the formula itself. The AB chapter's role now flips from
"prove the formula" to "feed Lane COE Step A1 and update stale prose".

## CRITICAL / HIGH — action before the next prover round

### CRIT-1 — [RESOLVED THIS REVIEW] COE blueprint Step A1 recipe had wrong helper names
`lean-vs-blueprint-checker coe-iter202` flagged a **must-fix**: the iter-203
Step A1 prover recipe in `Albanese_CodimOneExtension.tex`
(`subsec:stage6_iib_substrate_iter200`, 6 occurrences at L707/721/740/741/779/786)
named the two AB helpers WITHOUT the `.CohenMacaulay` namespace segment — an
iter-203 prover following the recipe verbatim would hit "unknown identifier".
**The review agent corrected all 6 occurrences to `RingTheory.CohenMacaulay.*`
this iter** (Lean-name correction in the review domain) and added a `% NOTE`
flagging the now-stale "currently private" prose. No further action needed on
the names; the plan agent should still refresh the surrounding "currently
private → promote" prose (now historical). (Source: coe-iter202 must-fix.)

### HIGH-1 — iter-203 Lane COE Step A1 is unblocked; use the CohenMacaulay namespace
The two AB helpers Lane COE Step A1 needs are now public. **They live in the
`RingTheory.CohenMacaulay` namespace, NOT bare `RingTheory.`:**
- `RingTheory.CohenMacaulay.isDomain_of_regularLocal`
- `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq`

PROGRESS.md and the iter-202 plan prose referred to them un-namespaced
(`RingTheory.isDomain_of_regularLocal`, etc.) — that is WRONG and will fail to
resolve cross-file. Fix the cross-file import directive in the iter-203 Lane COE
objective to use the fully-qualified names. With these visible, build the Step A1
Matsumura witness, then assemble B.d consuming the iter-202 §3.B bridges (B.a/B.b)
+ the iter-200 capstone `ringKrullDim_localization_atMaximal_MvPolynomial`.
(Source: AB task report "Important for Lane COE (iter-203)"; lean-auditor iter202
confirms `regularLocal_quotient_isRegularLocal_of_notMemSq` at L2626 is public and
used at L2813/L2902/L3011.)

### HIGH-2 — TensorObjSubstrate `monoidalCategory := sorry` instance is a contamination risk
`TensorObjSubstrate.lean:146` is `noncomputable instance monoidalCategory … := sorry`.
A sorry-bodied **instance** silently satisfies any future `MonoidalCategory X.Modules`
typeclass query (e.g. an `inferInstance` in a NEW axiom-clean file), which would
silently inject `sorryAx` into an otherwise-clean proof. Today it is contained
(all downstream callers are themselves stubs), but this matches the project's own
iter-193/195 Knowledge-Base soundness rule: **never `instance` on a sorry-bodied
typeclass derivation — use a `def`/`lemma` until the body closes, or gate behind
an explicit hypothesis class.** Before the iter-203 TS body fill begins, the plan
agent should either (a) demote `monoidalCategory` to a `def` + explicit-arg
threading until its body lands, or (b) accept it but record the risk in the TS
chapter `% NOTE`. (Source: lean-auditor iter202 Major.)

## MEDIUM — should be addressed but not blocking

### MED-1 — Sweep ~10 stale "typed sorry" comments in AuslanderBuchsbaum.lean
The file now has NO sorry in any proof position (lean-auditor confirms zero hits),
but ~10 header/docstring comments still describe closed bodies as "typed sorry"
and will mislead the iter-203 plan agent into thinking AB content is still open.
Stale sites: L40–42 (header "remaining five typed sorry bodies"), L144 (`depth`
docstring), L285 + L365 (`depth_eq_smallest_ext_index` "residual sorrys" + inline
`-- body remaining as sorry`), L638, L1706–1713 + L2043–2048 (`_succ_pd`
"single typed sorry"), L2239, L2523, L3387/L3390. These are `.lean` comments
(review agent cannot edit `.lean`) — dispatch a `refactor` subagent (comment-only
sweep) or fold into the next AB prover lane's directive. (Source: lean-auditor iter202.)

### MED-2 — Add `\lean{...}` blocks for 4 new public, axiom-clean helpers (WD ×2, AB ×2)
These sorry-free public declarations have no `\lean{...}`-pinned blueprint block,
so sync_leanok cannot track them. Adding the pinned blocks is plan-agent territory
(informal prose + `\lean{...}` hints). **Confirmed major by the checkers:**
- WD (wd-iter202): `Scheme.PrimeDivisor.functionFieldIso_compat`,
  `Scheme.PrimeDivisor.order_eq_order_restrict` — add `\begin{lemma}…\lean{…}`
  blocks in §3-Sub-build-3 (~L441–464). (wd-iter202 also notes a pre-existing
  minor: `isRegularInCodimOneProjectiveLineBar`, ~220 LOC axiom-clean, is also
  unpinned — lower priority.)
- AB (ab-iter202): `RingTheory.Module.depth_ses_ineqs_of_surjection_finite_localRing`
  (consumed by the `_succ_pd` inductive step) and
  `RingTheory.Module.exists_ne_zero_ext_of_depth_eq` (consumed by the base case)
  — the blueprint currently only describes the weaker `depth_ker_ge_min_…`; pin
  the actual call-sites.

### MED-3 — Refresh AB chapter staleness (Stacks 00MF OBVIATED + stale budget/prose)
`lean-vs-blueprint-checker ab-iter202` (6 major, all blueprint-side) +
lean-auditor (10 major stale `.lean` comments, see MED-1) confirm the AB chapter
needs a sweep now that the formula is closed:
- **Gap table (L569–585)**: mark gap (2) Stacks 00MF as **OBVIATED (Path B,
  iter-202)** — the matrix-collapse route closed the formula without it (analogous
  to gap (3) at iter-200).
- **"Iter budget refinement" paragraph (L661–678)**: estimates 5–8 more iters for
  a now-CLOSED lemma — stale and actively misleading for scheduling.
- **"currently private" prose + namespace** on the two promoted CohenMacaulay
  helpers (L1001–1012): now public; names need `.CohenMacaulay`. (Same root cause
  as CRIT-1/HIGH-1.)
- The stale iter-199/200/201 `% NOTE` chain on
  `lem:auslander_buchsbaum_formula_succ_pd` was already removed by this review.
Dispatch a blueprint-writer for the AB chapter next iter.

### MED-4 — TS: blueprint claims SymmetricMonoidalCategory but stub is MonoidalCategory; Piece 3d unstubbed
`lean-vs-blueprint-checker ts-iter202` (1 major): `thm:scheme_modules_monoidal`
prose claims a "symmetric MonoidalCategory" (braiding β + hexagon), but the Lean
stub `monoidalCategory` is the basic `MonoidalCategory` only. The downstream
consumer `addCommGroup_via_tensorObj` needs commutativity (the symmetric layer).
Before the iter-203 TS body fill: add a `SymmetricMonoidalCategory` stub (or
upgrade the instance head) — and note this composes with HIGH-2 (the sorry-bodied
instance contamination risk). Also informational: `lem:pullback_compatible_with_tensorobj`
(Piece 3d) has no Lean stub and is needed by the iter-204 consumer body — stub it
in iter-203. Plan agent should clarify the TS chapter's typeclass target.

## Promising / next-step work-list

- **TS body fill (iter-203+)**: `tensorObj` via `PresheafOfModules.Monoidal.tensorObj`
  + Zariski-site sheafification; `monoidalCategory` via `MonoidalCategoryStruct`
  assembly; `addCommGroup_via_tensorObj` via `QuotientAddGroup` descent (then swap
  into `RelPicFunctor.lean:235`, unblocking Lane RPF iter-204+).
  `lem:pullback_compatible_with_tensorobj` (Piece 3d) still has no stub.
- **Lane COE B.d** then becomes assemblable once Step A1 lands (HIGH-1).

## Blocked — do NOT re-assign without a structural change

- **WD `rationalMap_order_finite_support` non-zero branch** (L831): USER-blocked
  on the `[IsLocallyNoetherian X] → [IsNoetherian X]`/`[CompactSpace X]` signature
  strengthening. `order_eq_order_restrict` (landed this iter) is the open-chart
  naturality the terminal closure will consume, but the closure stays gated on
  the USER signature decision. Do NOT re-assign the terminal closure without it.
- **Route C lanes** (RRFormula, OCofP, OcOfD, RationalCurveIso, H1Vanishing,
  AbelianVarietyRigidity, RigidityKbar): PAUSED per USER 2026-05-28. Do not assign.
- **Lane COE B.d closed-point residue route**: provably INAPPLICABLE at a general
  codim-1 point (residue field is transc-deg-1 over kbar, not kbar). Do not retry
  that specific route; the Stacks-00OE Krull-dim formula is the correct path.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)

1. AB `_succ_pd` closure via `induction k generalizing M` (syzygy-descent step +
   matrix-collapse base); `ℕ∞` has no `IsStrictOrderedRing` → reduce to `ℕ` +
   `omega`; `by gcongr` for `+1` monotonicity; `ShortComplex.mk` zero via
   `rw[← ofHom_comp, show f∘ₗA=0]; rfl`.
2. `stalkSpecializes`/`germ` naturality: term-mode `(germ_stalkSpecializes _ _ _).trans …`
   over failing `rw`; `(stalkCongr e).hom = stalkSpecializes e.ge` is `rfl`;
   `h_compat` discharges by defeq via `congrArg (CommRingCat.Hom.hom · r)`.
3. `IsStandardSmoothOfRelativeDimension.out` re-export must use `Type`, not `Type*`
   (universe mismatch otherwise).

## Subagent reports (full text)

- `task_results/lean-auditor-iter202.md` — 0 must-fix; AB closure sound; 10 major
  stale-comment findings (MED-1) + monoidalCategory instance risk (HIGH-2).
- `task_results/lean-vs-blueprint-checker-ab-iter202.md` — 0 must-fix; AB closure
  faithful & axiom-clean; 6 major blueprint-staleness (→ MED-2, MED-3, HIGH-1).
- `task_results/lean-vs-blueprint-checker-coe-iter202.md` — **1 must-fix** (wrong
  helper namespace in Step A1 recipe → RESOLVED this review, CRIT-1) + 1 major
  (no §3.B blueprint section / missing pins for the 2 public bridges
  `isLocalization_atPrime_stalk_of_affineOpen`, `gammaSpecField_ringEquiv` →
  blueprint-writer next iter) + minor stale pin
  `…ringKrullDim_localization_eq_relativeDimension` (no such decl — detach/update).
- `task_results/lean-vs-blueprint-checker-wd-iter202.md` — 0 must-fix; both new
  decls faithful & axiom-clean; 2 major missing pins (→ MED-2).
- `task_results/lean-vs-blueprint-checker-ts-iter202.md` — 0 must-fix; 3/4 stubs
  faithful; 1 major (MonoidalCategory vs SymmetricMonoidalCategory → MED-4).

## Net: no live must-fix remains
The only must-fix this iter (COE Step A1 recipe namespace) was resolved in-review.
All other findings are blueprint-staleness / pin-additions for the iter-203 plan
agent (blueprint-writer dispatches), plus the HIGH-2 structural-soundness note to
heed before TS body fill. No prover lane is blocked by an unresolved must-fix.
