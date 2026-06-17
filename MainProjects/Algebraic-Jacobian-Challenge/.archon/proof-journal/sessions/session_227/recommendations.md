# Recommendations for iter-228 (review of iter-227)

## 0. HEADLINE — the terminal-grace tripwire has FIRED (route decision is now forced)

The iter-227 plan pre-committed: *if the A-bridge does not land axiom-clean this iter, OR the
C-probe shows C re-requires a tensor-stalk commutation (d.2), escalate the RR-pause fork to the
USER.* Outcome:
- **A-bridge `homOfLocalCompat` did NOT land** (only step ii `homMk`). → tripwire fires.
- **C-probe = decisively d.2-FREE** (the `restrictScalarsRingIsoDualEquiv` datapoint). → C-front clear.

So the tripwire fires on the A-front, but the cause is **build SIZE (~120–190 LOC gluing
engine), not d.2 re-emergence**. The route is mathematically sound and d.2-free on both fronts.
The escalation is surfaced to the USER via `TO_USER.md` as a LIVE FYI (the loop continues the
build by default). **The plan agent must respect the pre-commitment:** either the USER redirects
(via `USER_HINTS.md`), or iter-228 continues the bounded build per §1 below — but it must NOT
silently re-grant another open-ended grace window without a fresh progress-critic verdict, and
must NOT re-attempt the whole engine at the discredited 30–60 LOC estimate.

## 1. Closest-to-completion / next prover action (if the build continues)

**Do NOT re-dispatch the whole `homOfLocalCompat` engine as one objective.** The prover localized
the blocker: build **sub-piece (1) `localSection` (with its `naturality` field) FIRST, as its own
standalone axiom-clean lemma.** This is the ONLY step with real coherence risk
(`Over.map`/`Over.forget` interplay + eqToHom coherence across `Over (U i)` morphisms). Once it
lands, the remaining steps follow mechanically:
- (2) `IsCompatible` cocycle of `{localSection i}` (~30–50 LOC),
- (3) glue via `TopCat.Sheaf.existsUnique_gluing` + convert `s : (presheafHom F G).obj (op ⊤)` to
  `F ⟶ G` (terminal-`Over` equivalence / `presheafHomSectionsEquiv`) (~20–40 LOC),
- (4) sectionwise linearity + feed to `homMk` (already built) + restriction-recovery (~20–40 LOC).

Recommended route: `existsUnique_gluing` on `presheafHom (M.val.presheaf) (N.val.presheaf)` (a
sheaf of types via `Presheaf.IsSheaf.hom`, needs `N.isSheaf`) — NOT the raw `presheafHom_isSheafFor`
sieve route (also d.2-free but strictly more bookkeeping; reserve as fallback if (1)'s naturality
proves intractable). **Do NOT pin a sorry** (the build's no-stub invariant).

## 2. Blueprint actions for the plan agent (from lean-vs-blueprint-checker ts227 — 3 MAJOR)

`task_results/lean-vs-blueprint-checker-ts227.md`. 0 must-fix; the new decls are axiom-clean with
correct signatures. But (plan/blueprint-writer domain — NOT review marker actions):
1. **MAJOR — add `lem:restrictscalars_ringiso_dualequiv`** in `sec:tensorobj_dual_infra` with
   `\lean{restrictScalarsRingIsoDualEquiv}`, mirroring `lem:restrictscalars_ringiso_tensorequiv`
   for the dual case (the Lean docstring is sufficient source material).
2. **MAJOR — add a helper block for `Scheme.Modules.homMk`** near
   `lem:sheafofmodules_hom_of_local_compat` with `\lean{AlgebraicGeometry.Scheme.Modules.homMk}`
   ("A-bridge step (ii): scheme-level wrapper of `PresheafOfModules.homMk` packaging the
   sectionwise-linearity hypothesis"). Co-locate the `toPresheaf_map_homMk` companion (minor).
3. **MAJOR — expand the `homOfLocalCompat` proof sketch** (chapter L2823–2854): it is
   under-specified for the ~120–190 LOC implementation. Name the Lean API path (`existsUnique_gluing`
   vs `sheafHomSectionsEquiv`), flag the `localSection` naturality obligation explicitly, and revise
   the size estimate. This blueprint expansion is the cheapest lever to de-risk the §1 build —
   strongly recommended BEFORE the next prover round on this target.

These are the HARD-GATE inputs for iter-228: `Picard_TensorObjSubstrate.tex` should get a
blueprint-writer round addressing (1)–(3), then a scoped blueprint-reviewer re-check, before a
prover is dispatched on `localSection`/`homOfLocalCompat`.

## 3. Lean comment hygiene (from lean-auditor ts227 — 0 must-fix, 3 MINOR)

`task_results/lean-auditor-ts227.md`. All 3 new decls independently confirmed genuine/axiom-clean.
Minor comment-staleness for the next prover ride-along (prover owns the .lean file):
- **L2070** — stale line ref "at L1912"; `tensorObj_isLocallyTrivial` is now ~L1962. Fix the number.
- **L103–113** — the `RestrictScalarsRingIsoTensor` section header still calls the ring-iso strong
  upgrade "absent … the REAL bottom gap (H2) of `tensorObj_restrict_iso`"; that gap is filled and
  `tensorObj_restrict_iso` axiom-clean since iter-217. Clarify "absent from Mathlib".
- **L36–95** — the module Status block (last updated iter-224) does not mention the iter-227
  additions `restrictScalarsRingIsoDualEquiv`/`homMk`/`toPresheaf_map_homMk`. Refresh.

## 4. Do-NOT-retry / blocked

- **Do NOT re-estimate `homOfLocalCompat` at ~30–60 LOC.** That estimate is discredited (grounded
  ~120–190 LOC, skeleton typechecked). Budget the realistic size.
- **Do NOT pivot to building the abandoned d.2 stalk-⊗** to unblock this route — both the A-front
  (gluing) and C-front (dual-vs-restriction) are confirmed d.2-free. d.2 is not needed.
- **Do NOT dispatch sub-step 5 `exists_tensorObj_inverse` directly** — it consumes BOTH bridges
  (A `homOfLocalCompat` + C `dual_isLocallyTrivial`), neither of which exists yet. Pinning the
  consumer first is the iter-214 d.1 anti-pattern.
- **Do NOT re-attempt the FORBIDDEN sheafify-the-presheaf-eval shortcut** (re-hits `M ◁ η` = d.2,
  confirmed dead end).
- The 3 file sorries (L691 `isLocallyInjective_whiskerLeft_of_W`, L2096 `exists_tensorObj_inverse`,
  L2142 `addCommGroup_via_tensorObj`) remain FORBIDDEN/out-of-scope until their upstream bridges land.

## 5. Reusable proof patterns discovered (also in PROJECT_STATUS.md Knowledge Base)

- **`restrictScalarsRingIsoDualEquiv`** (C-build H2′): base change along a ring iso `e : R ≃+* S`
  commutes with the linear dual `Hom(-,R)`. Forward `φ ↦ e.symm∘φ`, inverse `ψ ↦ e∘ψ`; `Module R`
  via `Module.compHom · e.toRingHom` in the SIGNATURE (`letI`); linearity via `hsmulM : r•m = e r•m`
  (`rfl`) + `map_smul`/`map_mul`/`e.symm_apply_apply`. Axiom-clean `{propext, Quot.sound}`. Because
  `restrictScalars` along a ring iso is an EQUIVALENCE, it commutes with `Hom(-,-)` in both variances
  — so the contravariant dual is d.2-free just as the tensor was.
- **`Scheme.Modules.homMk`**: wrap `PresheafOfModules.homMk (M₁:=M.val)(M₂:=N.val) g hg` in `⟨·⟩`.
  Linearity hyp MUST be over `X.ringCatSheaf.obj.obj V` / `M.val.obj V`, and `g` over
  `M.val.presheaf ⟶ N.val.presheaf` syntactically (the `Scheme.Modules.presheaf` def does not unfold
  for instance synthesis). Defining property `toPresheaf_map_homMk := rfl`. A section-level
  `((homMk g hg).val.app V).hom = (g.app V).hom` simp lemma is FALSE-TYPED — use the `Ab`-level
  `toPresheaf` identity.
